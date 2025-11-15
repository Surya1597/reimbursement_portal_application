class BillController < ApplicationController
  before_action :require_login
  before_action :set_employee_profile, only: %i[new create]
  before_action :set_bill, only: :update
  before_action :require_admin!, only: :update

  def new
    @bill = @employee_profile.bills.new
  end

  def create
    @bill = @employee_profile.bills.new(bill_params)

    if @bill.save
      redirect_to reimbursement_dashboard_employee_index_path, notice: "Bill submitted for review."
    else
      flash.now[:alert] = "Please fix the issues below."
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @bill.update(bill_status_params.merge(reviewed_by: current_user, reviewed_at: Time.current))
      redirect_back fallback_location: admin_bills_dashboard_path, notice: "Bill updated successfully."
    else
      redirect_back fallback_location: admin_bills_dashboard_path, alert: "Unable to update bill."
    end
  end

  private

  def bill_params
    params.require(:bill).permit(:amount, :bill_type, :other_reason)
  end

  def bill_status_params
    params.require(:bill).permit(:status)
  end

  def set_employee_profile
    @employee_profile = current_user.employee_profile
    return if @employee_profile

    redirect_to reimbursement_dashboard_employee_index_path,
                alert: "Create your employee profile before submitting bills."
  end

  def set_bill
    @bill = Bill.find(params[:id])
  end

  def require_admin!
    return if current_user&.admin?

    redirect_to reimbursement_dashboard_employee_index_path,
                alert: "You are not authorized to perform this action."
  end
end
