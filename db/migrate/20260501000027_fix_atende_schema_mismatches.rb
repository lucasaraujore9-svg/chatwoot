class FixAtendeSchemaMismatches < ActiveRecord::Migration[7.0]
  def change
    # 1. atende_flows: add status enum column (model uses status, migration had is_published)
    unless column_exists?(:atende_flows, :status)
      add_column :atende_flows, :status, :string, default: 'draft', null: false
      add_index :atende_flows, [:account_id, :status]
    end

    # 2. atende_agent_capacity_policies: model expects agent_id + max_conversations + is_active
    unless column_exists?(:atende_agent_capacity_policies, :agent_id)
      add_column :atende_agent_capacity_policies, :agent_id, :bigint
      add_column :atende_agent_capacity_policies, :max_conversations, :integer
      add_column :atende_agent_capacity_policies, :is_active, :boolean, default: true, null: false
      add_index :atende_agent_capacity_policies, :agent_id
      add_index :atende_agent_capacity_policies, [:account_id, :agent_id], unique: true,
                                                                           name: 'idx_atende_capacity_policies_account_agent'
      add_foreign_key :atende_agent_capacity_policies, :agents, on_delete: :cascade
    end

    # 3. atende_copilot_messages: model belongs_to :account, validates account_id
    unless column_exists?(:atende_copilot_messages, :account_id)
      add_column :atende_copilot_messages, :account_id, :bigint, null: false, default: 0
      add_index :atende_copilot_messages, :account_id
      add_foreign_key :atende_copilot_messages, :accounts, on_delete: :cascade
      # Remove artificial default after adding
      change_column_default :atende_copilot_messages, :account_id, nil
    end

    # 4. atende_applied_slas: model belongs_to :account, validates account_id
    unless column_exists?(:atende_applied_slas, :account_id)
      add_column :atende_applied_slas, :account_id, :bigint, null: false, default: 0
      add_index :atende_applied_slas, :account_id
      add_foreign_key :atende_applied_slas, :accounts, on_delete: :cascade
      change_column_default :atende_applied_slas, :account_id, nil
    end

    # 5. atende_sla_policies: model uses scope :active -> where(is_active: true)
    return if column_exists?(:atende_sla_policies, :is_active)

    add_column :atende_sla_policies, :is_active, :boolean, default: true, null: false
  end
end
