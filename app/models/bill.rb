class Bill < ApplicationRecord
  belongs_to :employee_profile
  belongs_to :reviewed_by, class_name: "User", optional: true

  enum :bill_type, { travel: 0, food: 1, accommodation: 2, other: 3 }
  enum :status, { pending: 0, approved: 1, rejected: 2 }

  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :bill_type, presence: true
  validates :other_reason, presence: true, if: -> { bill_type == "other" }
end
