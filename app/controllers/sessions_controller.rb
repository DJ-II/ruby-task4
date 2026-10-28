class SessionsController < ApplicationController
  skip_before_action :require_active_user, only: [:new, :create]

  def new
  end

  def create
    email = params[:email].to_s.strip.downcase
    user = User.find_by(email: email)

    if user&.authenticate(params[:password].to_s)
      if user.blocked?
        flash.now[:alert] = "This account is blocked."
        render :new, status: :unprocessable_entity
      else
        reset_session
        session[:user_id] = user.id
        user.update_columns(last_login_at: Time.current, last_activity_at: Time.current)
        redirect_to users_path, notice: "Signed in successfully.", status: :see_other
      end
    else
      flash.now[:alert] = "Invalid email or password."
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    reset_session
    redirect_to login_path, notice: "Signed out successfully.", status: :see_other
  end
end
