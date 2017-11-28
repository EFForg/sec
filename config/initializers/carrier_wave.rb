
CarrierWave.configure do |config|
  config.root = Rails.root.join("files")
end unless ENV["NO_NGINX"]
