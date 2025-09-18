module Localize
  extend ActiveSupport::Concern

  included do
    around_action :switch_locale
    around_action :switch_timezone
  end

  private
    def switch_locale(&action)
      # Priority order: family setting > session > browser detection > default
      locale = Current.family.try(:locale) ||
               session[:locale] ||
               detect_locale_from_browser ||
               I18n.default_locale
      
      # Store detected locale in session for future requests
      unless Current.family&.locale
        session[:locale] = locale.to_s
      end
      
      I18n.with_locale(locale, &action)
    end

    def switch_timezone(&action)
      timezone = Current.family.try(:timezone) || Time.zone
      Time.use_zone(timezone, &action)
    end
    
    def detect_locale_from_browser
      return nil unless request.env['HTTP_ACCEPT_LANGUAGE']
      return session[:locale] if session[:locale].present?

      # Parse Accept-Language header
      accepted_languages = request.env['HTTP_ACCEPT_LANGUAGE']
                                  .split(',')
                                  .map { |lang| lang.split(';').first.strip.downcase }

      # Language mapping to handle common cases
      language_mappings = {
        'zh-tw' => 'zh-TW',
        'zh-hk' => 'zh-TW',
        'zh-mo' => 'zh-TW',
        'zh-cn' => 'zh-TW', # Default Chinese to Traditional
        'zh' => 'zh-TW',
        'pt-br' => 'pt',
        'pt-pt' => 'pt',
        'es-es' => 'es',
        'es-mx' => 'es',
        'es-ar' => 'es',
        'ko-kr' => 'ko',
        'ja-jp' => 'ja'
      }

      accepted_languages.each do |lang|
        # Check direct mapping first
        if language_mappings[lang]
          mapped_locale = language_mappings[lang]
          return mapped_locale if I18n.available_locales.include?(mapped_locale.to_sym)
        end
        
        # Check if the language is directly supported
        return lang if I18n.available_locales.include?(lang.to_sym)
        
        # Try language part only (e.g., 'pt' from 'pt-br')
        lang_part = lang.split('-').first
        if I18n.available_locales.include?(lang_part.to_sym)
          return lang_part
        end
      end

      nil
    end
    
    def set_user_locale(locale)
      if I18n.available_locales.include?(locale.to_sym)
        session[:locale] = locale.to_s
        
        # Update family preference if user is logged in and family exists
        if Current.family
          Current.family.update(locale: locale.to_s)
        end
        
        true
      else
        false
      end
    end
end
