def wait_until
  require "timeout"
  Timeout::timeout(5) do
    sleep(0.1) until value = yield
    value
  end
end
