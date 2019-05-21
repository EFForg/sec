# Various patches so that path helpers work correctly
# when called from feature/request/helper specs.

RSpec.configure do |config|
  config.before(:example) do
    default = I18n.locale == I18n.default_locale ? nil : I18n.locale

    helpers = Rails.application.routes.url_helpers

    allow(Rails.application.routes).
      to receive(:url_helpers).
          and_return(helpers)

    url_opts = Rails.application.routes.url_helpers.url_options.reverse_merge(locale: default)

    allow(Rails.application.routes.url_helpers).
      to receive(:url_options).
          and_return(url_opts)

    if respond_to?(:default_url_options)
      default_url_options[:locale] ||= default
    end

    if respond_to?(:helper) && helper.try(:default_url_options)
      url_opts = helper.url_options.reverse_merge(locale: default)

      allow(helper).
        to receive(:url_options).
            and_return(url_opts)

      helper.default_url_options[:locale] ||= default
    end
  end
end
