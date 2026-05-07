class AddCustomRoleIdToAccountUsers < ActiveRecord::Migration[7.0]
  def change
    # Upstream Chatwoot (v4.13+) already adds custom_role_id to account_users
    # via migration 20240726220747_add_custom_roles.rb — skip if present.
    return if column_exists?(:account_users, :custom_role_id)

    add_column :account_users, :custom_role_id, :bigint
    add_index :account_users, :custom_role_id
    add_foreign_key :account_users, :atende_custom_roles, column: :custom_role_id, on_delete: :nullify
  end
end
