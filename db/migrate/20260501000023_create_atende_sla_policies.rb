class CreateAtendeSLAPolicies < ActiveRecord::Migration[7.0]
  def change
    create_table :atende_sla_policies do |t|
      t.bigint :account_id, null: false
      t.string :name, null: false
      t.integer :first_response_time_threshold
      t.integer :next_response_time_threshold
      t.integer :resolution_time_threshold
      t.boolean :business_hours_only, default: false, null: false
      t.jsonb :conditions, default: {}
      t.timestamps
    end

    add_index :atende_sla_policies, :account_id
    add_foreign_key :atende_sla_policies, :accounts, on_delete: :cascade
  end
end
