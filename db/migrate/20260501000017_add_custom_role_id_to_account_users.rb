class AddCustomRoleIdToAccountUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :account_users, :custom_role_id, :bigint
    add_index :account_users, :custom_role_id
    add_foreign_key :account_users, :atende_custom_roles, column: :custom_role_id, on_delete: :nullify
  end
end
