class AddDeletedAtToDailyInvoices < ActiveRecord::Migration[5.0]
  def change
    add_column :daily_invoices, :deleted_at, :datetime
    add_index :daily_invoices, :deleted_at
  end
end
