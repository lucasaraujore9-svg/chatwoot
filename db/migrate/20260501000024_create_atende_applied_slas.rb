class CreateAtendeAppliedSlas < ActiveRecord::Migration[7.0]
  def change
    create_table :atende_applied_slas do |t|
      t.bigint :sla_policy_id, null: false
      t.bigint :conversation_id, null: false
      t.string :sla_status, default: 'active', null: false
      t.datetime :first_response_at
      t.datetime :resolved_at
      t.timestamps
    end

    add_index :atende_applied_slas, :conversation_id
    add_index :atende_applied_slas, [:sla_policy_id, :sla_status]
    add_foreign_key :atende_applied_slas, :atende_sla_policies, column: :sla_policy_id, on_delete: :cascade
    add_foreign_key :atende_applied_slas, :conversations, on_delete: :cascade
  end
end
