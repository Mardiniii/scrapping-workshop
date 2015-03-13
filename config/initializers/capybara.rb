require "capybara/dsl"
require "capybara/webkit"

Capybara.run_server = false
Capybara.default_wait_time = 5

Capybara.configure do |c|
    c.javascript_driver = :webkit
    c.default_driver = :webkit
end