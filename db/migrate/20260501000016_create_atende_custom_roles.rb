class CreateAtendeCustomRoles < ActiveRecord::Migration[7.0]
  def change
    create_table :atende_custom_roles do |t|
      t.bigint :account_id, null: false
      t.string :name, null: false
      t.text :description
      t.jsonb :permissions, default: []
      t.timestamps
    end

    add_index :atende_custom_roles, [:account_id, :name], unique: true
    add_foreign_key :atende_custom_roles, :accounts, on_delete: :cascade
  end
end
