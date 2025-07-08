# frozen_string_literal: true

class DashboardPage < BasePage
  def visit_page
    visit '/'
  end

  def user_name
    find('.user-name').text
  end

  def user_points_balance
    find('.points-balance').text.to_i
  end

  def click_rewards_link
    click_link 'Browse Rewards'
  end

  def click_history_link
    click_link 'Redemption History'
  end

  def has_welcome_message?
    has_content?('Welcome')
  end

  def has_points_display?
    has_css?('.points-balance')
  end
end
