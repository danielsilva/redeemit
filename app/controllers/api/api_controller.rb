# frozen_string_literal: true

module Api
  # Base API Controller
  class ApiController < ActionController::API
    rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
    rescue_from ActiveRecord::RecordInvalid, with: :record_invalid

    private

    def record_not_found
      render json: { error: 'Record not found' }, status: :not_found
    end

    def record_invalid(exception)
      render json: { error: exception.message }, status: :unprocessable_entity
    end
  end
end
