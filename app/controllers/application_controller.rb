class ApplicationController < ActionController::API
  include Authentication
  include Pundit::Authorization

  rescue_from ActiveRecord::RecordNotFound,       with: :not_found
  rescue_from ActionController::ParameterMissing, with: :missing_param_error
  rescue_from Pundit::NotAuthorizedError,         with: :not_authorized

private

  def not_authorized
    render json: nil, status: :forbidden
  end

  def not_found
    render json: nil, status: :not_found
  end

  def missing_param_error(exception)
    render json: { error: exception.message }, status: :unprocessable_entity
  end
end
