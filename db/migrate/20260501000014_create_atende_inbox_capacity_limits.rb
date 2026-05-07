class CreateAtendeInboxCapacityLimits < ActiveRecord::Migration[7.0]
  def change
    create_table :atende_inbox_capacity_limits do |t|
      t.bigint :account_id, null: false
      t.bigint :inbox_id, null: false
      t.integer :conversation_limit, null: false
      t.timestamps
    end

    add_index :atende_inbox_capacity_limits, [:account_id, :inbox_id], unique: true
    add_foreign_key :atende_inbox_capacity_limits, :accounts, on_delete: :cascade
    add_foreign_key :atende_inbox_capacity_limits, :inboxes, on_delete: :cascade
  end
end
