# == Schema Information
#
# Table name: atende_companies
#
#  id                    :bigint           not null, primary key
#  additional_attributes :jsonb
#  custom_attributes     :jsonb
#  description           :text
#  domain                :string
#  industry              :string
#  name                  :string           not null
#  website               :string
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  account_id            :bigint           not null
#  owner_id              :bigint
#
# Indexes
#
#  index_atende_companies_on_account_id_and_domain  (account_id,domain)
#  index_atende_companies_on_account_id_and_name    (account_id,name) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (account_id => accounts.id) ON DELETE => cascade
#
module Atende
  class Company < ApplicationRecord
    self.table_name = 'atende_companies'

    belongs_to :account
    has_many :company_contacts, class_name: 'Atende::CompanyContact', dependent: :destroy
    has_many :contacts, through: :company_contacts

    validates :account_id, :name, presence: true

    scope :for_account, ->(account_id) { where(account_id: account_id) }
  end
end
