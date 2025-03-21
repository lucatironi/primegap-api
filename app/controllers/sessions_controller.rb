class SessionsController < ApplicationController
  allow_unauthenticated_access only: %i[ create ]

  rate_limit to: 10, within: 3.minutes, only: :create, with: -> {
    render json: { error: "Too many attempts" }, status: :unauthorized
  }

  def create
    @current_user = User.find_by(email_address: params[:email_address])

    if @current_user && @current_user.authenticate(params[:password])
      encoded_token = encode(@current_user)
      @current_user.sessions.create!(
        ip_address:   request.remote_ip,
        user_agent:   request.user_agent)

      render json: { token: encoded_token }, status: :ok
    else
      render json: { error: "Invalid email or password" }, status: :unauthorized
    end
  end
end
