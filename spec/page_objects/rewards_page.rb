class RewardsPage < BasePage
  def visit_page
    visit '/rewards'
  end

  def has_reward?(reward_name)
    has_content?(reward_name)
  end

  def reward_card(reward_name)
    find('[data-testid="reward-card"]', text: reward_name)
  end

  def redeem_reward(reward_name)
    within reward_card(reward_name) do
      click_button 'Redeem'
    end
  end

  def reward_points_cost(reward_name)
    within reward_card(reward_name) do
      find('[data-testid="points-cost"]').text.to_i
    end
  end

  def reward_available_quantity(reward_name)
    within reward_card(reward_name) do
      find('[data-testid="available-quantity"]').text.to_i
    end
  end

  def has_redeem_button?(reward_name)
    within reward_card(reward_name) do
      has_button?('Redeem')
    end
  end

  def has_insufficient_points_message?
    has_content?('Insufficient points')
  end

  def has_out_of_stock_message?(reward_name)
    within reward_card(reward_name) do
      has_content?('Out of Stock')
    end
  end
end
