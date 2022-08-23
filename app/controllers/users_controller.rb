class UsersController < ApplicationController
rescue_from ActiveRecord::RecordNotFound, with: :render_not_logged_in_response

  def create
    user = User.create(user_params)
    if user.valid?
      session[:user_id] = user.id
      render json: user, status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def show
    user = User.find(session[:user_id])
    if user
      render json: user, status: :accepted
    else
      render json: { errors: user.errors.full_messages }, status: :unauthorized
    end
  end

  private

  def user_params
    params.permit(:username, :password, :password_confirmation)
  end

  def render_not_logged_in_response
    render json: { error: "You are not logged in" }, status: :unauthorized
  end

end