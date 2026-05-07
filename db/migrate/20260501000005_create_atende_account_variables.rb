class CreateAtendeAccountVariables < ActiveRecord::Migration[7.0]
  def change
    create_table :atende_account_variables do |t|
      t.bigint :account_id, null: false
      t.string :key, null: false
      t.text :value_encrypted
      t.string :var_type, default: 'string', null: false
      t.boolean :is_secret, default: false, null: false
      t.timestamps
    end

    add_index :atende_account_variables, [:account_id, :key], unique: true
    add_foreign_key :atende_account_variables, :accounts, on_delete: :cascade
  end
end
