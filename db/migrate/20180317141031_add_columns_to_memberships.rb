class AddColumnsToMemberships < ActiveRecord::Migration[5.1]
  def change
    add_column :memberships, :invitation_token, :string
    add_column :memberships, :invited_at, :datetime
    add_column :memberships, :invited_by_id, :integer, foreign_key: { to_table: :users, on_delete: :cascade }
    add_column :memberships, :invitation_accepted_at, :datetime

    add_index :memberships, :invitation_token, unique: true
    add_index :memberships, [:organization_id, :user_id], unique: true

    remove_foreign_key :memberships, :organizations
    remove_foreign_key :memberships, :users

    add_foreign_key :memberships, :organizations, on_delete: :cascade
    add_foreign_key :memberships, :users, on_delete: :cascade
  end
end
