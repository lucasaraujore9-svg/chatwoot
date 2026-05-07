class CreateAtendeInboxAssignments < ActiveRecord::Migration[7.0]
  def change
    create_table :atende_inbox_assignments do |t|
      t.bigint :account_id, null: false
      t.bigint :inbox_id, null: false
      t.string :kind, null: false
      t.bigint :flow_id
      t.bigint :agent_id
      t.boolean :is_active, default: true, null: false
      t.timestamps
    end

    add_index :atende_inbox_assignments, [:inbox_id, :is_active],
              unique: true,
              where: 'is_active = TRUE',
              name: 'index_atende_inbox_assignments_one_active_per_inbox'
    add_index :atende_inbox_assignments, :account_id
    add_foreign_key :atende_inbox_assignments, :accounts, on_delete: :cascade
    add_foreign_key :atende_inbox_assignments, :inboxes, on_delete: :cascade
    add_foreign_key :atende_inbox_assignments, :atende_flows, column: :flow_id, on_delete: :cascade
  end
end
