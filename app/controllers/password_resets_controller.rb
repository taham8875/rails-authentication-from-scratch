class PasswordResetsController < ApplicationController
  before_action :set_user_by_token, only: [:edit, :update]

  def new
  end

  def create
    user = User.find_by(email: params[:email])
    if user
      PasswordMailer.with(
        user: user,
        token: user.generate_token_for(:password_reset)
      ).password_reset.deliver_later
    redirect_to root_url, notice: "Email sent with password reset instructions."
    else
      flash.now[:error] = "Email address not found."
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @user.update(password_params)
      redirect_to new_session_path, notice: "Password updated. Please sign in."
    else
      flash.now[:error] = "Password not updated."
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_user_by_token
    @user = User.find_by_token_for(:password_reset, params[:token])
    puts @user.inspect
    redirect_to new_password_reset_path, alert: "Invalid token." unless @user.present?
  end

  def password_params
    params.require(:user).permit(:password, :password_confirmation)
  end
end
