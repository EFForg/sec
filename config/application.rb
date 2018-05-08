require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module TrainersHub
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    config.exceptions_app = self.routes

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    config.action_controller.default_url_options = {
      host: ENV["SERVER_HOST"],
      port: ENV["SERVER_PORT"],
      protocol: ENV["SERVER_PROTOCOL"]
    }

    if ENV["NO_NGINX"]
      require_dependency "zip_middleware"
      config.middleware.use ZipMiddleware
    end
  end
end
