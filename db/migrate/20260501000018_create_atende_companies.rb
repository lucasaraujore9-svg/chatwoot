class CreateAtendeCompanies < ActiveRecord::Migration[7.0]
  def change
    create_table :atende_companies do |t|
      t.bigint :account_id, null: false
      t.string :name, null: false
      t.string :domain
      t.jsonb :custom_attributes, default: {}
      t.bigint :owner_id
      t.timestamps
    end

    add_index :atende_companies, [:account_id, :domain]
    add_index :atende_companies, [:account_id, :name], unique: true
    add_foreign_key :atende_companies, :accounts, on_delete: :cascade
  end
end
