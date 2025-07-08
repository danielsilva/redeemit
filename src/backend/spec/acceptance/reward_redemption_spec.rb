require 'rails_helper'

RSpec.describe 'Reward Redemption', type: :acceptance, js: true do
  let!(:user) { create(:user, :with_high_balance) }
  let!(:reward) { create(:reward, :popular) }
  let(:dashboard_page) { page_object(DashboardPage) }
  let(:rewards_page) { page_object(RewardsPage) }
  let(:history_page) { page_object(RedemptionHistoryPage) }

  before do
    # In a real app, you'd handle authentication here
    # For now, assume user is already logged in
    dashboard_page.visit_page
  end

  it 'redeems a reward' do
    dashboard_page.click_rewards_link
    
    expect(rewards_page).to have_reward(reward.name)
    expect(rewards_page).to have_redeem_button(reward.name)
    
    initial_quantity = rewards_page.reward_available_quantity(reward.name)
    
    # Redeem the reward
    rewards_page.redeem_reward(reward.name)
    
    # Verify success message or updated state
    expect(rewards_page).to have_success_message('Reward redeemed successfully')
    
    # Verify quantity decreased
    expect(rewards_page.reward_available_quantity(reward.name)).to eq(initial_quantity - 1)
    
    # Navigate to history and verify redemption appears
    rewards_page.click_link('History')
    expect(history_page).to have_redemption(reward.name)
    expect(history_page).to have_recent_redemption(reward.name)
  end

  it 'cannot redeem reward with insufficient points' do
    create(:user, :with_low_balance) # Switch to this user context
    expensive_reward = create(:reward, :expensive)
    
    # Navigate to rewards
    dashboard_page.click_rewards_link
    
    # Attempt to redeem expensive reward
    rewards_page.redeem_reward(expensive_reward.name)
    
    # Verify error message
    expect(rewards_page).to have_insufficient_points_message
    
    # Verify redemption didn't occur
    history_page.visit_page
    expect(history_page).not_to have_redemption(expensive_reward.name)
  end

  it 'cannot redeem out of stock reward' do
    out_of_stock_reward = create(:reward, :out_of_stock)
    
    dashboard_page.click_rewards_link
    
    # Verify out of stock message
    expect(rewards_page).to have_out_of_stock_message
    expect(rewards_page).not_to have_redeem_button(out_of_stock_reward.name)
  end
end