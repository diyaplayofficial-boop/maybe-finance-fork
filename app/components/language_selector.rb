class LanguageSelector < ApplicationComponent
  def initialize(current_locale: I18n.locale, classes: nil)
    @current_locale = current_locale
    @classes = classes
  end

  private

  attr_reader :current_locale, :classes

  def available_languages
    I18n.available_locales.map do |locale|
      {
        code: locale,
        name: t("languages.#{locale}"),
        current: locale == current_locale.to_sym
      }
    end
  end

  def component_classes
    base_classes = "language-selector"
    [base_classes, classes].compact.join(" ")
  end
end