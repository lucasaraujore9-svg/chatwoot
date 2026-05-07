class CreateAtendeNodeRuns < ActiveRecord::Migration[7.0]
  def change
    create_table :atende_node_runs do |t|
      t.bigint :session_id, null: false
      t.string :node_id, null: false
      t.string :node_type, null: false
      t.string :status, null: false
      t.jsonb :input, default: {}
      t.jsonb :output, default: {}
      t.text :error_message
      t.integer :duration_ms
      t.datetime :executed_at, null: false
      t.timestamps
    end

    add_index :atende_node_runs, [:session_id, :executed_at]
    add_foreign_key :atende_node_runs, :atende_sessions, column: :session_id, on_delete: :cascade
  end
end
