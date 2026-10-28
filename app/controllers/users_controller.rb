class UsersController < ApplicationController
  def index
    @users = User.recent_first
  end

  def bulk
    ids = Array(params[:user_ids]).filter_map do |value|
      Integer(value, 10)
    rescue ArgumentError, TypeError
      nil
    end.uniq

    if ids.empty?
      redirect_to users_path, alert: "Select at least one user.", status: :see_other
      return
    end

    users = User.where(id: ids)

    case params[:operation]
    when "block"
      affected = users.update_all(blocked: true, updated_at: Time.current)
      message = "#{affected} user(s) blocked."
    when "unblock"
      affected = users.update_all(blocked: false, updated_at: Time.current)
      message = "#{affected} user(s) unblocked."
    when "delete"
      affected = users.destroy_all.size
      message = "#{affected} user(s) deleted."
    else
      redirect_to users_path, alert: "Unknown action.", status: :see_other
      return
    end

    if User.where(id: session[:user_id], blocked: false).exists?
      redirect_to users_path, notice: message, status: :see_other
    else
      reset_session
      redirect_to login_path, alert: "Your account is no longer active. You have been signed out.", status: :see_other
    end
  end
end
