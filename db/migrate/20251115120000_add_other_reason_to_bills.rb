class AddOtherReasonToBills < ActiveRecord::Migration[7.2]
  def change
    add_column :bills, :other_reason, :text
  end
end
