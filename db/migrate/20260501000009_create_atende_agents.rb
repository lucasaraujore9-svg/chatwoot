class CreateAtendeAgents < ActiveRecord::Migration[7.0]
  def change
    create_table :atende_agents do |t|
      t.bigint :account_id, null: false
      t.bigint :llm_credential_id, null: false
      t.string :name, null: false
      t.text :description
      t.string :model, null: false
      t.text :system_prompt
      t.decimal :temperature, precision: 3, scale: 2, default: '0.7'
      t.integer :max_tokens, default: 1000
      t.integer :history_limit, default: 20
      t.jsonb :tools_config, default: {}
      t.jsonb :dynamic_config, default: {}
      t.string :pause_label
      t.string :routing_strategy
      t.bigint :routing_agent_id
      t.bigint :routing_team_id
      t.string :notify_mode
      t.text :notify_template
      t.boolean :is_active, default: true, null: false
      t.timestamps
    end

    add_index :atende_agents, [:account_id, :is_active]
    add_foreign_key :atende_agents, :accounts, on_delete: :cascade
    add_foreign_key :atende_agents, :atende_llm_credentials, column: :llm_credential_id, on_delete: :restrict
  end
end
