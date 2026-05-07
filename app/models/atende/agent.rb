module Atende
  class Agent < ApplicationRecord
    self.table_name = 'atende_agents'

    belongs_to :account
    belongs_to :llm_credential, class_name: 'Atende::LlmCredential'
    has_many :sessions, class_name: 'Atende::Session'
    has_many :inbox_assignments, class_name: 'Atende::InboxAssignment'

    validates :name, presence: true
    validates :model, presence: true
    validates :temperature, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 2 }

    scope :active, -> { where(is_active: true) }
    scope :for_account, ->(account_id) { where(account_id: account_id) }
  end
end
