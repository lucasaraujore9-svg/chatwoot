class CreateAtendeSessions < ActiveRecord::Migration[7.0]
  def change
    create_table :atende_sessions do |t|
      t.bigint :account_id, null: false
      t.bigint :conversation_id, null: false
      t.bigint :contact_id, null: false
      t.bigint :flow_id
      t.bigint :agent_id
      t.string :kind, null: false
      t.string :status, default: 'active', null: false
      t.string :current_node_id
      t.jsonb :variables, default: {}
      t.datetime :started_at
      t.datetime :last_activity_at
      t.datetime :ended_at
      t.timestamps
    end

    add_index :atende_sessions, :conversation_id
    add_index :atende_sessions, [:account_id, :status, :last_activity_at],
              name: 'idx_atende_sessions_account_status_activity'
    add_index :atende_sessions, [:conversation_id, :status],
              unique: true,
              where: "status = 'active'",
              name: 'index_atende_sessions_one_active_per_conversation'
    add_foreign_key :atende_sessions, :accounts, on_delete: :cascade
    add_foreign_key :atende_sessions, :conversations, on_delete: :cascade
    add_foreign_key :atende_sessions, :contacts, on_delete: :cascade
    add_foreign_key :atende_sessions, :atende_flows, column: :flow_id, on_delete: :nullify
  end
end
