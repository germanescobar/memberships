class AddCurrentOrganizationToUsers < ActiveRecord::Migration[5.1]
  def change
    add_reference :users, :current_organization, foreign_key: { to_table: :organizations }
  end
end
