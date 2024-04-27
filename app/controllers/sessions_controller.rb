class SessionsController < ApplicationController
  def new
  end

  def create
    if user = User.authenticate_by(email: params[:email], password: params[:password])
      login user
      redirect_to root_path
    else
      flash[:alert] = "Invalid email or password."
      redirect_to new_session_path, status: :unauthorized
    end
  end

  def destroy
    logout
    redirect_to root_path, notice: "You have been logged out."
  end
end
