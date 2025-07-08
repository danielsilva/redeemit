
require 'rails_helper'

RSpec.describe Api::RedemptionsController, type: :request do
  let(:user) { create(:user, :with_high_balance) }
  let(:reward) { create(:reward) }

  describe 'POST /api/redemptions' do
    context 'with valid parameters' do
      let(:valid_params) do
        {
          user_id: user.id,
          reward_id: reward.id
        }
      end

      it 'creates a new redemption' do
        expect do
          post '/api/redemptions', params: valid_params, as: :json
        end.to change(Redemption, :count).by(1)

        expect(response).to have_http_status(:created)

        redemption = Redemption.last
        expect(redemption.user).to eq(user)
        expect(redemption.reward).to eq(reward)
        expect(redemption.reward_name).to eq(reward.name)
        expect(redemption.points_used).to eq(reward.points_cost)
        expect(redemption.redeemed_at).to be_present
      end

      it 'decreases reward available quantity' do
        initial_quantity = reward.available_quantity

        post '/api/redemptions', params: valid_params, as: :json

        reward.reload
        expect(reward.available_quantity).to eq(initial_quantity - 1)
      end

      it 'decreases user points balance' do
        initial_balance = user.points_balance

        post '/api/redemptions', params: valid_params, as: :json

        user.reload
        expect(user.points_balance).to eq(initial_balance - reward.points_cost)
      end

      it 'returns the created redemption' do
        post '/api/redemptions', params: valid_params, as: :json

        json_response = JSON.parse(response.body)
        expect(json_response['reward_name']).to eq(reward.name)
        expect(json_response['points_used']).to eq(reward.points_cost)
        expect(json_response['redeemed_at']).to be_present
      end
    end
  end
end
