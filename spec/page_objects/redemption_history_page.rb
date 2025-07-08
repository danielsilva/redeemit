class RedemptionHistoryPage < BasePage
  def visit_page
    visit '/history'
  end

  def has_redemption?(reward_name)
    has_content?(reward_name)
  end

  def redemption_row(reward_name)
    find('[data-testid="redemption-row"]', text: reward_name)
  end

  def redemption_points_used(reward_name)
    within redemption_row(reward_name) do
      find('[data-testid="points-used"]').text.to_i
    end
  end

  def redemption_date(reward_name)
    within redemption_row(reward_name) do
      find('[data-testid="redeemed-at"]').text
    end
  end

  def redemptions_count
    all('[data-testid="redemption-row"]').count
  end

  def has_no_redemptions_message?
    has_content?('No redemptions found')
  end

  def has_recent_redemption?(reward_name)
    within redemption_row(reward_name) do
      date_text = find('[data-testid="redeemed-at"]').text
      Date.parse(date_text) >= Date.current
    end
  end
end
