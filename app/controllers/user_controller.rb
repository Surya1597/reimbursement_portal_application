class UserController < ApplicationController
  before_action :require_login
  before_action :require_admin
  before_action :set_user, only: %i[update destroy]

  def admin_bills_dashboard
    @bills = Bill.includes(employee_profile: %i[user department]).order(created_at: :desc)
    assign_bill_metrics
  end

  def index
    @new_user = User.new
    load_form_requirements
  end

  def create
    @new_user = User.new
    assign_user_attributes(@new_user)

    if @new_user.errors.empty? && @new_user.save!
      update_employee_profile(@new_user)
      redirect_to admin_users_path, notice: "User created successfully."
    else
      @open_new_user_modal = true
      load_form_requirements
      render :index, status: :unprocessable_entity
    end
  end

  def update
    assign_user_attributes(@user)

    if @user.errors.empty? && @user.save
      update_employee_profile(@user)
      redirect_to admin_users_path, notice: "User updated successfully."
    else
      @new_user = User.new
      @edited_user_id = @user.id
      load_form_requirements(user_with_errors: @user)
      render :index, status: :unprocessable_entity
    end
  end

  def destroy
    if @user == current_user
      redirect_to admin_users_path, alert: "You cannot delete the currently logged in account." and return
    end

    @user.destroy
    redirect_to admin_users_path, notice: "User deleted successfully."
  end

  private

  def require_admin
    return if current_user&.admin?

    redirect_to reimbursement_dashboard_employee_index_path,
                alert: "You are not authorized to access that page."
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :role, :password, :password_confirmation,
                                 :profile_department_id, :profile_designation)
  end

  def assign_bill_metrics
    approved_bills = @bills.select { |bill| bill.status == "approved" }
    pending_bills = @bills.select { |bill| bill.status == "pending" }
    rejected_bills = @bills.select { |bill| bill.status == "rejected" }

    @approved_amount = approved_bills.sum(&:amount)
    @pending_amount = pending_bills.sum(&:amount)
    @rejected_amount = rejected_bills.sum(&:amount)
    @total_amount = @bills.sum(&:amount)

    @approved_bills = approved_bills.count
    @pending_bills = pending_bills.count
    @rejected_bills = rejected_bills.count
    @total_bills = @bills.count
  end

  def assign_user_attributes(user)
    attrs = user_params
    user.first_name = attrs[:first_name].to_s.strip
    user.last_name = attrs[:last_name].to_s.strip
    user.name = [user.first_name, user.last_name].reject(&:blank?).join(" ")
    user.email = attrs[:email].to_s.strip
    user.role = attrs[:role]
    user.profile_department_id = attrs[:profile_department_id].presence&.to_i
    user.profile_designation = attrs[:profile_designation].presence

    validate_profile_attributes(user)
    assign_password(user, attrs[:password], attrs[:password_confirmation])
  end

  def validate_profile_attributes(user)
    user.errors.add(:first_name, "can't be blank") if user.first_name.blank?
    user.errors.add(:last_name, "can't be blank") if user.last_name.blank?
    user.errors.add(:email, "can't be blank") if user.email.blank?
    user.errors.add(:role, "can't be blank") if user.role.blank?
    user.errors.add(:profile_department_id, "can't be blank") if user.profile_department_id.blank?
    user.errors.add(:profile_designation, "can't be blank") if user.profile_designation.blank?
  end

  def assign_password(user, password, confirmation)
    if user.new_record?
      if password.blank?
        user.errors.add(:password, "can't be blank")
      elsif password != confirmation
        user.errors.add(:password_confirmation, "does not match Password")
      elsif !PASSWORD_REGEX.match?(password)
        user.errors.add(:password, "must be 8 to 25 characters long, contain at least one uppercase letter, one number, one special character, and must not include spaces")
      else
        user.password_digest = BCrypt::Password.create(password)
      end
    elsif password.present?
      if password != confirmation
        user.errors.add(:password_confirmation, "does not match Password")
      elsif !PASSWORD_REGEX.match?(password)
        user.errors.add(:password, "must be 8 to 25 characters long, contain at least one uppercase letter, one number, one special character, and must not include spaces")
      else
        user.password_digest = BCrypt::Password.create(password)
      end
    end
  end

  def update_employee_profile(user)
    return if user.profile_department_id.blank? || user.profile_designation.blank?

    attributes = {
      first_name: user.first_name,
      last_name: user.last_name,
      department_id: user.profile_department_id,
      designation: user.profile_designation
    }

    profile = user.employee_profile

    if profile
      profile.update(attributes)
    else
      EmployeeProfile.create!(attributes.merge(user: user))
    end
  end

  def load_form_requirements(user_with_errors: nil)
    @departments = Department.order(:name)
    @designation_options = EmployeeProfile.designations.keys
    @users = User.includes(employee_profile: :department).order(:name)

    if user_with_errors
      @users = @users.map { |existing| existing.id == user_with_errors.id ? user_with_errors : existing }
    end

    @users.each { |user| hydrate_user_form_fields(user) }
  end

  def hydrate_user_form_fields(user)
    profile = user.employee_profile
    return unless profile

    user.first_name ||= profile.first_name
    user.last_name ||= profile.last_name
    user.profile_department_id ||= profile.department_id
    user.profile_designation ||= profile.designation
  end

  def set_user
    @user = User.includes(employee_profile: :department).find(params[:id])
    hydrate_user_form_fields(@user)
  end
end
