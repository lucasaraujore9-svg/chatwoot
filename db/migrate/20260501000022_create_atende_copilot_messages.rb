class CreateAtendeCopilotMessages < ActiveRecord::Migration[7.0]
  def change
    create_table :atende_copilot_messages do |t|
      t.bigint :thread_id, null: false
      t.string :role, null: false
      t.text :content
      t.string :llm_provider
      t.string :llm_model
      t.integer :prompt_tokens
      t.integer :completion_tokens
      t.timestamps
    end

    add_index :atende_copilot_messages, [:thread_id, :created_at]
    add_foreign_key :atende_copilot_messages, :atende_copilot_threads, column: :thread_id, on_delete: :cascade
  end
end
