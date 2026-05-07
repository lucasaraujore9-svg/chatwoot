class CreateAtendeFlows < ActiveRecord::Migration[7.0]
  def change
    create_table :atende_flows do |t|
      t.bigint :account_id, null: false
      t.string :name, null: false
      t.text :description
      t.integer :version, default: 1, null: false
      t.boolean :is_published, default: false, null: false
      t.jsonb :graph, default: {}
      t.timestamps
    end

    add_index :atende_flows, [:account_id, :is_published]
    add_foreign_key :atende_flows, :accounts, on_delete: :cascade
  end
end
