module Atende
  class LlmCredential < ApplicationRecord
    self.table_name = 'atende_llm_credentials'

    belongs_to :account
    has_many :agents, class_name: 'Atende::Agent'

    PROVIDERS = %w[openai anthropic google ollama].freeze
    VALIDATION_STATUSES = %w[valid invalid unknown].freeze

    validates :provider, presence: true, inclusion: { in: PROVIDERS }
    validates :label, presence: true
    validates :validation_status, inclusion: { in: VALIDATION_STATUSES }

    scope :for_account, ->(account_id) { where(account_id: account_id) }
  end
end
