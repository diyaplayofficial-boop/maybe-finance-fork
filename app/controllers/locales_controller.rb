class LocalesController < ApplicationController
  def update
    locale = params[:locale]
    
    if I18n.available_locales.include?(locale.to_sym)
      session[:locale] = locale.to_s
      
      # Update family preference if user is logged in and family exists
      if Current.family
        Current.family.update(locale: locale.to_s)
      end
      
      redirect_back(fallback_location: root_path, notice: t('locale.changed'))
    else
      redirect_back(fallback_location: root_path, alert: t('locale.invalid'))
    end
  end
end