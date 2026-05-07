class AddDefaultCompanyIdToContacts < ActiveRecord::Migration[7.0]
  def change
    add_column :contacts, :default_company_id, :bigint
    add_index :contacts, :default_company_id
    add_foreign_key :contacts, :atende_companies, column: :default_company_id, on_delete: :nullify
  end
end
