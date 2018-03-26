# Don't prevent form fills by bots during the test run
InvisibleCaptcha.setup do |config|
  config.timestamp_enabled = false
end
