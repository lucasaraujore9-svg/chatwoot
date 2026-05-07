module Atende
  class AccountVariable < ApplicationRecord
    self.table_name = 'atende_account_variables'

    belongs_to :account

    validates :key, presence: true, format: { with: /\A[a-z][a-z0-9_]*\z/, message: 'must be snake_case (lowercase letters, digits, underscores)' }
    validates :key, uniqueness: { scope: :account_id }
    validates :var_type, inclusion: { in: %w[string number boolean] }

    scope :for_account, ->(account_id) { where(account_id: account_id) }
  end
end
