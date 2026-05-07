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
