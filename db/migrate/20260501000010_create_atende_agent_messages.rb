class CreateAtendeAgentMessages < ActiveRecord::Migration[7.0]
  def change
    create_table :atende_agent_messages do |t|
      t.bigint :session_id, null: false
      t.string :role, null: false
      t.text :content
      t.jsonb :tool_calls, default: []
      t.string :tool_call_id
      t.string :tool_name
      t.integer :prompt_tokens
      t.integer :completion_tokens
      t.timestamps
    end

    add_index :atende_agent_messages, [:session_id, :created_at]
    add_foreign_key :atende_agent_messages, :atende_sessions, column: :session_id, on_delete: :cascade
  end
end
