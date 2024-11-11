require 'capybara'
require 'rspec'

RSpec.configure do |config|
  config.add_formatter 'documentation'
  config.add_formatter 'html', 'results.html'

  config.after(:each) do |ex|
    if ex.exception
      Dir.mkdir('screenshots') unless Dir.exist?('screenshots')

      timestamp = Time.now.strftime("%Y-%m-%d_%H-%M-%S")
      filename = "screenshots/#{timestamp}_#{ex.description.gsub(' ', '_')}.png"
      page.save_screenshot(filename)
    end
  end
end

Capybara.default_driver = :selenium_chrome_headless
Capybara.app_host = 'https://www.saucedemo.com'