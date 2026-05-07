class CreateAtendeCompanyContacts < ActiveRecord::Migration[7.0]
  def change
    create_table :atende_company_contacts do |t|
      t.bigint :company_id, null: false
      t.bigint :contact_id, null: false
      t.timestamps
    end

    add_index :atende_company_contacts, [:company_id, :contact_id], unique: true
    add_foreign_key :atende_company_contacts, :atende_companies, column: :company_id, on_delete: :cascade
    add_foreign_key :atende_company_contacts, :contacts, column: :contact_id, on_delete: :cascade
  end
end
