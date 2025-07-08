# Capybara configuration for acceptance tests
require 'capybara/rspec'
require 'selenium-webdriver'

Capybara.configure do |config|
  config.default_max_wait_time = 5
  config.default_normalize_ws = true
  config.ignore_hidden_elements = true
  config.match = :prefer_exact
  config.exact = false
  config.raise_server_errors = true
  config.visible_text_only = true
end

# Setup Chrome headless driver
Capybara.register_driver :selenium_chrome_headless do |app|
  options = Selenium::WebDriver::Chrome::Options.new
  options.add_argument('--headless')
  options.add_argument('--no-sandbox')
  options.add_argument('--disable-dev-shm-usage')
  options.add_argument('--disable-gpu')
  options.add_argument('--window-size=1920,1080')

  Capybara::Selenium::Driver.new(app, browser: :chrome, options: options)
end

# Setup Chrome with head (for debugging)
Capybara.register_driver :selenium_chrome do |app|
  options = Selenium::WebDriver::Chrome::Options.new
  options.add_argument('--no-sandbox')
  options.add_argument('--disable-dev-shm-usage')
  options.add_argument('--window-size=1920,1080')
  options.add_argument('--disable-blink-features=AutomationControlled')
  
  # Enable DevTools and debugging features
  options.add_argument('--enable-logging')
  options.add_argument('--log-level=0')
  options.add_argument('--remote-debugging-port=9222')
  
  # Keep browser open longer for debugging
  options.add_argument('--disable-backgrounding-occluded-windows')
  options.add_argument('--disable-renderer-backgrounding')

  Capybara::Selenium::Driver.new(app, browser: :chrome, options: options)
end

# Set default driver
Capybara.default_driver = :rack_test
Capybara.javascript_driver = :selenium_chrome

# Configure server to use dynamic ports
Capybara.server = :puma, { Silent: true }
Capybara.server_host = 'localhost'
Capybara.server_port = nil # Let Capybara choose a random available port

# Force a new server instance for each test run
Capybara.reuse_server = false

# For acceptance tests, use the visible Chrome driver and manage server lifecycle
RSpec.configure do |config|
  config.before(:each, type: :acceptance) do
    # Set visible Chrome driver
    Capybara.current_driver = :selenium_chrome
    
    # Reset sessions and ensure fresh server start
    Capybara.reset_sessions!
    Capybara.current_session.server.boot if Capybara.current_session.server.respond_to?(:boot)
  end
  
  config.after(:each, type: :acceptance) do
    # Clean up sessions and return to default driver
    Capybara.reset_sessions!
    Capybara.use_default_driver
  end
end

# Helper method to open DevTools programmatically
def open_devtools
  return unless Capybara.current_driver == :selenium_chrome
  
  begin
    # Try to open DevTools using Chrome DevTools Protocol
    page.driver.browser.action.key_down(:f12).perform
    sleep(0.5) # Give DevTools time to open
  rescue => e
    puts "Could not open DevTools automatically: #{e.message}"
    puts "You can manually open DevTools by pressing F12 in the Chrome window"
  end
end