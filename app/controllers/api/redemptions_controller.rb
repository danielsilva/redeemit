module Api
  # Controller for handling reward redemptions
  class RedemptionsController < Api::ApiController
    def index
      user = User.find(params[:user_id])
      redemptions = user.redemptions.includes(:reward).order(redeemed_at: :desc)

      render json: redemptions.map { |redemption| serialize_redemption(redemption) }
    end

    def create
      user = User.find(params[:user_id])
      reward = Reward.find(params[:reward_id])

      redeem(user, reward)
    end

    private

    def redeem(user, reward)
      ActiveRecord::Base.transaction do
        redemption = create_redemption(user, reward)
        update_user_and_reward(user, reward)
        render_success_response(redemption, user)
      end
    end

    def create_redemption(user, reward)
      Redemption.create!(
        user: user,
        reward: reward,
        points_used: reward.points_cost
      )
    end

    def update_user_and_reward(user, reward)
      user.update!(points_balance: user.points_balance - reward.points_cost)
      reward.update!(available_quantity: reward.available_quantity - 1)
    end

    def serialize_redemption(redemption)
      {
        id: redemption.id,
        reward_name: redemption.reward&.name,
        points_used: redemption.points_used,
        redeemed_at: redemption.redeemed_at
      }
    end

    def render_success_response(redemption, user)
      render json: {
        id: redemption.id,
        reward_name: redemption.reward.name,
        points_used: redemption.points_used,
        redeemed_at: redemption.redeemed_at,
        remaining_balance: user.points_balance
      }, status: :created
    end
  end
end
