module Atende
  class CustomRole < ApplicationRecord
    self.table_name = 'atende_custom_roles'

    belongs_to :account

    validates :account_id, :name, presence: true
    validates :name, uniqueness: { scope: :account_id }

    scope :for_account, ->(account_id) { where(account_id: account_id) }
  end
end
