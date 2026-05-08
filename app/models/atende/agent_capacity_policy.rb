module Atende
  class AgentCapacityPolicy < ApplicationRecord
    self.table_name = 'atende_agent_capacity_policies'

    belongs_to :account
    belongs_to :agent, class_name: '::User'

    validates :account_id, :agent_id, :max_conversations, presence: true
    validates :max_conversations, numericality: { greater_than: 0, less_than_or_equal_to: 1000 }
    validates :agent_id, uniqueness: { scope: :account_id }

    scope :active, -> { where(is_active: true) }
    scope :for_account, ->(account_id) { where(account_id: account_id) }
  end
end
