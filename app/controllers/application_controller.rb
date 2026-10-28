class ApplicationController < ActionController::Base
  before_action :require_active_user
  helper_method :current_user

  private

  def current_user
    @current_user
  end

  def require_active_user
    user = User.find_by(id: session[:user_id])

    unless user && !user.blocked?
      reason = user&.blocked? ? "Your account has been blocked. Please contact an administrator." : "Your session has ended. Please log in again."
      reset_session
      redirect_to login_path, alert: reason, status: :see_other
      return
    end

    @current_user = user
    user.update_column(:last_activity_at, Time.current)
  end
end
