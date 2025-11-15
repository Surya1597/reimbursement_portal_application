class User < ApplicationRecord
  has_secure_password

  has_one :employee_profile, dependent: :destroy
  has_many :bills, foreign_key: "reviewed_by", dependent: :destroy

  # attr_accessor :raw_password
  attr_accessor :profile_department_id
  attr_accessor :profile_designation
  attr_accessor :first_name
  attr_accessor :last_name

  enum :role, { admin: 0, employee: 1 }

  validates :email, presence: true,
                    format: { with: EMAIL_REGEX, message: "must be a valid email" },
                    uniqueness: { case_sensitive: false }

  # validate :check_password_format, if: -> { raw_password.present? }

  # before_save :encrypt_password, if: -> { raw_password.present? }

  private

  def check_password_format
    unless PASSWORD_REGEX.match?(raw_password)
      errors.add(:password_digest, "must be 8 to 25 characters long, contain at least one uppercase letter, one number, one special character, and must not include spaces")
    end
  end

  def encrypt_password
    self.password_digest = BCrypt::Password.create(raw_password)
  end
end
