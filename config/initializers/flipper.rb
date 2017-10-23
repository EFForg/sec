require "flipper"
require "flipper/adapters/pstore"

Flipper.configure do |config|
  config.default do
    adapter = Flipper::Adapters::PStore.new
    Flipper.new(adapter)
  end
end

if Rails.env.production?
  Flipper.disable(:lesson_plans)
else
  Flipper.enable(:lesson_plans)
end
