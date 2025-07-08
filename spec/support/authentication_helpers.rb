# frozen_string_literal: true

module AuthenticationHelpers
  def switch_user(user)
    @current_user = user
    # In a real app, you'd set session/cookies here
    # For now, we'll use a simple approach to simulate user switching
    Capybara.current_session.execute_script("localStorage.setItem('current_user_id', '#{user.id}');")
    # Reload the page to pick up the new user context
    Capybara.current_session.refresh
  end

  def sign_in_as(user)
    switch_user(user)
    visit root_path
  end

  def current_user
    @current_user
  end
end