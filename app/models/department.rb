class Department < ApplicationRecord
  has_many :employee_profiles, dependent: :destroy
end
