
require 'rails_helper'

RSpec.describe Api::RedemptionsController, type: :request do
  let(:user) { create(:user, :with_high_balance) }

  describe 'POST /api/redemptions' do
    context 'with insufficient user points' do
      let(:poor_user) { create(:user, :with_no_points) }
      let(:expensive_reward) { create(:reward, :expensive) }
      let(:invalid_params) do
        {
          user_id: poor_user.id,
          reward_id: expensive_reward.id
        }
      end

      it 'does not create a redemption' do
        expect do
          post '/api/redemptions', params: invalid_params, as: :json
        end.not_to change(Redemption, :count)

        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns an error message' do
        post '/api/redemptions', params: invalid_params, as: :json

        json_response = JSON.parse(response.body)
        expect(json_response['error']).to include('Insufficient points')
      end
    end

    context 'with out of stock reward' do
      let(:out_of_stock_reward) { create(:reward, :out_of_stock) }
      let(:invalid_params) do
        {
          user_id: user.id,
          reward_id: out_of_stock_reward.id
        }
      end

      it 'does not create a redemption' do
        expect do
          post '/api/redemptions', params: invalid_params, as: :json
        end.not_to change(Redemption, :count)

        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns an error message' do
        post '/api/redemptions', params: invalid_params, as: :json

        json_response = JSON.parse(response.body)
        expect(json_response['error']).to include('Reward is out of stock')
      end
    end
  end
end
