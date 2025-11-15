class EmployeeController < ApplicationController
  before_action :require_login

  def reimbursement_dashboard
    @employee_profile = current_user.employee_profile
    @bills = @employee_profile.bills

    get_required_details
  end

  private

  def get_required_details
    approved_bills = @bills.where(status: "approved")
    pending_bills = @bills.where(status: "pending")
    rejected_bills = @bills.where(status: "rejected")

    @approved_amount = approved_bills.sum(:amount)
    @pending_amount = pending_bills.sum(:amount)
    @rejected_amount = rejected_bills.sum(:amount)
    @total_amount = @bills.sum(:amount)

    @approved_bills = approved_bills.count
    @pending_bills = pending_bills.count
    @rejected_bills = rejected_bills.count
    @total_bills = @bills.count
  end
end
