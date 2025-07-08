# frozen_string_literal: true

class DashboardPage < BasePage
  def visit_page
    visit '/'
  end

  def user_name
    find('[data-testid="user-name"]').text
  end

  def user_points_balance
    find('[data-testid="points-balance"]').text.to_i
  end

  def click_rewards_link
    click_on 'Browse Rewards'
  end

  def click_history_link
    click_on 'Redemption History'
  end

  def has_welcome_message?
    has_content?('Welcome')
  end

  def has_points_display?
    has_css?('[data-testid="points-balance"]')
  end
end
