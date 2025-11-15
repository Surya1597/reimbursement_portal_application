class CreateBills < ActiveRecord::Migration[7.2]
  def change
    create_table :bills do |t|
      t.references :employee_profile, null: false, foreign_key: true
      t.references :reviewed_by, foreign_key: { to_table: :users }, null: true
      t.float :amount, null: false
      t.integer :bill_type, null: false
      t.integer :status, null: false, default: 0
      t.datetime :reviewed_at

      t.timestamps
    end
  end
end
