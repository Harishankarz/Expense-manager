class AddCloumnAmountToExpenses < ActiveRecord::Migration[5.0]
  def change
    add_column :expenses, :amount, :integer
  end
end
