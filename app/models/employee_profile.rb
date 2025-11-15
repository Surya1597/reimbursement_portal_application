class EmployeeProfile < ApplicationRecord
  belongs_to :user
  belongs_to :department

  has_many :bills, dependent: :destroy

  enum :designation, { intern: 0, junior: 1, senior: 2, lead: 3, manager: 4 }
end
