class PasswordsController < ApplicationController
  before_action :authenticate_user!

  def edit
  end

  def update
    if current_user.update(password_params)
      redirect_to root_path, notice: "Password updated."
    else
      flash.now[:error] = "Password not updated."
      render :edit, status: :unprocessable_entity
    end
  end

  def create
    user = User.find_by_email(params[:email])
    if user
      user.send_password_reset
      redirect_to root_url, :notice => "Email sent with password reset instructions."
    else
      flash.now[:error] = "Email address not found."
      render 'new'
    end
  end

  private

  def password_params
    # user can edit the html to bypass the password challenge and rails will skip the validation if the password is nil
    params.require(:user).permit(:password_challenge, :password, :password_confirmation).with_defaults(password_challenge: "")
  end
end
