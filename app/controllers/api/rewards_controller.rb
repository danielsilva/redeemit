# frozen_string_literal: true

module Api
  class RewardsController < Api::ApiController
    def index
      rewards = Reward.available.order(:points_cost)

      render json: rewards.map do |reward|
        {
          id: reward.id,
          name: reward.name,
          description: reward.description,
          points_cost: reward.points_cost,
          available_quantity: reward.available_quantity
        }
      end
    end
  end
end
