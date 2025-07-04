class Api::RedemptionsController < Api::ApiController
  def create
    user = User.find(params[:user_id])
    reward = Reward.find(params[:reward_id])

    unless user.can_redeem?(reward)
      return render json: {
        error: "Insufficient points or reward not available"
      }, status: :unprocessable_entity
    end

    ActiveRecord::Base.transaction do
      user.update!(points_balance: user.points_balance - reward.points_cost)
      reward.update!(available_quantity: reward.available_quantity - 1)

      redemption = Redemption.create!(
        user: user,
        reward: reward,
        points_used: reward.points_cost
      )

      render json: {
        id: redemption.id,
        reward_name: reward.name,
        points_used: redemption.points_used,
        redeemed_at: redemption.redeemed_at,
        remaining_balance: user.points_balance
      }, status: :created
    end
  rescue ActiveRecord::RecordNotFound => e
    render json: { error: "User or reward not found" }, status: :not_found
  rescue ActiveRecord::RecordInvalid => e
    render json: { error: e.message }, status: :unprocessable_entity
  end
end
