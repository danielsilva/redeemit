# Base Page Object class
class BasePage
  include Capybara::DSL
  include RSpec::Matchers

  def initialize
    # Optional: visit a default path
  end

  def current_path
    page.current_path
  end

  def has_success_message?(message)
    has_css?('[data-testid="success-message"]', text: message)
    click_on 'OK'
  end

  def has_error_message?(message)
    has_css?('[data-testid="error-message"]', text: message)
    click_on 'OK'
  end
end
