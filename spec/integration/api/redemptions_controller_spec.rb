# frozen_string_literal: true

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

  describe 'GET /api/users/:id/redemptions' do
    let!(:redemptions) { create_list(:redemption, 3, user: user) }

    it 'returns all redemptions for the user' do
      get "/api/users/#{user.id}/redemptions", as: :json

      expect(response).to have_http_status(:ok)

      json_response = JSON.parse(response.body)
      expect(json_response.length).to eq(3)

      json_response.each do |redemption_json|
        expect(redemption_json).to include(
          'points_used' => be_a(Integer),
          'reward_id' => be_a(Integer)
        )
      end
    end

    it 'returns redemptions in descending order by redeemed_at' do
      create(:redemption, :old, user: user)
      create(:redemption, :recent, user: user)

      get "/api/users/#{user.id}/redemptions", as: :json

      json_response = JSON.parse(response.body)
      first_redemption_date = Date.parse(json_response.first['redeemed_at'])
      last_redemption_date = Date.parse(json_response.last['redeemed_at'])

      expect(first_redemption_date).to be >= last_redemption_date
    end
  end
end
