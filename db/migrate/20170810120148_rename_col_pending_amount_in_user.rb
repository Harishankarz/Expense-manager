class RenameColPendingAmountInUser < ActiveRecord::Migration[5.0]
  def change
  rename_column :users, :pending_amount, :amount_to_be_paid
  end
end
