class CreateAtendeSlaEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :atende_sla_events do |t|
      t.bigint :applied_sla_id, null: false
      t.string :event_type, null: false
      t.datetime :occurred_at, null: false
      t.timestamps
    end

    add_index :atende_sla_events, [:applied_sla_id, :event_type]
    add_foreign_key :atende_sla_events, :atende_applied_slas, column: :applied_sla_id, on_delete: :cascade
  end
end
