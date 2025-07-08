# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::UsersController, type: :request do
  let(:user) { create(:user, :with_high_balance) }

  describe 'GET /api/users/:id/redemptions' do
    let!(:redemptions) { create_list(:redemption, 3, user: user) }

    it 'returns all redemptions for the user' do
      get "/api/users/#{user.id}/redemptions", as: :json

      expect(response).to have_http_status(:ok)

      json_response = JSON.parse(response.body)
      expect(json_response.length).to eq(3)

      redemption_ids = redemptions.map(&:id)
      json_response.each do |redemption_json|
        expect(redemption_json).to include(
          'id' => be_in(redemption_ids),
          'reward_name' => be_a(String),
          'points_used' => be_a(Integer),
          'redeemed_at' => be_a(String)
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
