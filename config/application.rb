require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module TrainersHub
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.


    config.action_controller.default_url_options = {}
    if ENV["RAILS_RELATIVE_URL_ROOT"]
      config.action_controller.default_url_options.merge!(
        script_name: ENV["RAILS_RELATIVE_URL_ROOT"]
      )
    end
  end
end
