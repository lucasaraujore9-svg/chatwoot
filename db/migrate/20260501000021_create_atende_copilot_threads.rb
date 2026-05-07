class CreateAtendeCopilotThreads < ActiveRecord::Migration[7.0]
  def change
    create_table :atende_copilot_threads do |t|
      t.bigint :account_id, null: false
      t.bigint :conversation_id, null: false
      t.bigint :user_id, null: false
      t.timestamps
    end

    add_index :atende_copilot_threads, [:conversation_id, :user_id], unique: true
    add_foreign_key :atende_copilot_threads, :accounts, on_delete: :cascade
    add_foreign_key :atende_copilot_threads, :conversations, on_delete: :cascade
    add_foreign_key :atende_copilot_threads, :users, on_delete: :cascade
  end
end
