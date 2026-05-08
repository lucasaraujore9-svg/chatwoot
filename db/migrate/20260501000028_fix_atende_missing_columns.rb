class FixAtendeMissingColumns < ActiveRecord::Migration[7.0]
  def change
    # atende_sla_policies: view references description but migration didn't create it
    add_column :atende_sla_policies, :description, :text unless column_exists?(:atende_sla_policies, :description)

    # atende_companies: view references website, industry, description, additional_attributes
    return if column_exists?(:atende_companies, :website)

    add_column :atende_companies, :website, :string
    add_column :atende_companies, :industry, :string
    add_column :atende_companies, :description, :text
    add_column :atende_companies, :additional_attributes, :jsonb, default: {}
  end
end
