module Atende
  class CompanyContact < ApplicationRecord
    self.table_name = 'atende_company_contacts'

    belongs_to :company, class_name: 'Atende::Company'
    belongs_to :contact

    validates :company_id, :contact_id, presence: true
    validates :contact_id, uniqueness: { scope: :company_id }
  end
end
