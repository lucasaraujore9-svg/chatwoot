class CreateAtendeAgentCapacityPolicies < ActiveRecord::Migration[7.0]
  def change
    create_table :atende_agent_capacity_policies do |t|
      t.bigint :account_id, null: false
      t.string :name, null: false
      t.integer :conversation_limit, null: false
      t.jsonb :inbox_limits, default: {}
      t.timestamps
    end

    add_index :atende_agent_capacity_policies, :account_id
    add_foreign_key :atende_agent_capacity_policies, :accounts, on_delete: :cascade
  end
end
