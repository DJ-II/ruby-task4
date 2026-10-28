class RegistrationsController < ApplicationController
  skip_before_action :require_active_user

  def new
    @user = User.new
  end

  def create
    @user = User.new(registration_params)

    if @user.save
      reset_session
      session[:user_id] = @user.id
      @user.update_columns(last_login_at: Time.current, last_activity_at: Time.current)
      redirect_to users_path, notice: "Account created successfully.", status: :see_other
    else
      render :new, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotUnique
    @user.errors.add(:email, "is already registered")
    render :new, status: :unprocessable_entity
  end

  private

  def registration_params
    params.require(:user).permit(:name, :email, :password)
  end
end
