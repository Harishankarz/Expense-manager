class AddColumnIsContributorToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :is_contributor, :boolean
  end
end
