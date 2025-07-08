# frozen_string_literal: true

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
    has_css?('.alert-success, .notice', text: message)
  end

  def has_error_message?(message)
    has_css?('.alert-danger, .alert, .error', text: message)
  end

  def wait_for_ajax
    Timeout.timeout(Capybara.default_max_wait_time) do
      loop until finished_all_ajax_requests?
    end
  end

  private

  def finished_all_ajax_requests?
    page.evaluate_script('jQuery.active').zero?
  rescue StandardError
    true
  end
end
