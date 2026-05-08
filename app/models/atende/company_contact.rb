# == Schema Information
#
# Table name: atende_company_contacts
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  company_id :bigint           not null
#  contact_id :bigint           not null
#
# Indexes
#
#  index_atende_company_contacts_on_company_id_and_contact_id  (company_id,contact_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (company_id => atende_companies.id) ON DELETE => cascade
#  fk_rails_...  (contact_id => contacts.id) ON DELETE => cascade
#
module Atende
  class CompanyContact < ApplicationRecord
    self.table_name = 'atende_company_contacts'

    belongs_to :company, class_name: 'Atende::Company'
    belongs_to :contact

    validates :company_id, :contact_id, presence: true
    validates :contact_id, uniqueness: { scope: :company_id }
  end
end
