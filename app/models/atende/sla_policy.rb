module Atende
  class SlaPolicy < ApplicationRecord
    self.table_name = 'atende_sla_policies'

    belongs_to :account

    validates :account_id, :name, presence: true
    validates :name, uniqueness: { scope: :account_id }

    scope :active, -> { where(is_active: true) }
    scope :for_account, ->(account_id) { where(account_id: account_id) }
  end
end
