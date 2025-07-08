# frozen_string_literal: true

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
  end
end
