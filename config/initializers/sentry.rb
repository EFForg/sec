if ENV["SENTRY_DSN"].present?
  Raven.configure do |config|
    config.dsn = ENV["SENTRY_DSN"]
  end
end
