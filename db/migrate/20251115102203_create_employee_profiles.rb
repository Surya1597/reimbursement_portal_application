class CreateEmployeeProfiles < ActiveRecord::Migration[7.2]
  def change
    create_table :employee_profiles do |t|
      t.references :user, null: false, foreign_key: true
      t.references :department, null: false, foreign_key: true
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.integer :designation, null: false

      t.timestamps
    end
  end
end
