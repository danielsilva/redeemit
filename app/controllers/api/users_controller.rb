
module Api
  # Controller for handling users
  class UsersController < Api::ApiController
    def balance
      user = User.find(params[:id])
      render json: {
        user_id: user.id,
        name: user.name,
        points_balance: user.points_balance
      }
    rescue ActiveRecord::RecordNotFound
      render json: { error: 'User not found' }, status: :not_found
    end

    def redemptions
      user = User.find(params[:id])
      redemptions = user.redemptions.includes(:reward).order(redeemed_at: :desc)

      render json: redemptions.map { |redemption| serialize_redemption(redemption) }
    rescue ActiveRecord::RecordNotFound
      render json: { error: 'User not found' }, status: :not_found
    end

    private

    def serialize_redemption(redemption)
      {
        id: redemption.id,
        reward_name: redemption.reward&.name,
        points_used: redemption.points_used,
        redeemed_at: redemption.redeemed_at
      }
    end
  end
end
