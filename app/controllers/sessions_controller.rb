class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:email])

    if user&.authenticate(params[:password])
      session[:user_id] = user.id

      case user.role
      when "admin"
        redirect_to admin_users_path, notice: "Logged in!"
      when "employee"
        redirect_to reimbursement_dashboard_employee_index_path, notice: "Logged in!"
      else
        redirect_to login_sessions_path, alert: "Unknown role"
      end
    else
      flash.now[:alert] = "Invalid email or password"
      render :new
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to login_sessions_path, notice: "Logged out!"
  end
end
