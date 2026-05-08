# == Schema Information
#
# Table name: atende_llm_credentials
#
#  id                :bigint           not null, primary key
#  api_key_encrypted :text
#  extra_config      :jsonb
#  is_default        :boolean          default(FALSE), not null
#  label             :string           not null
#  last_validated_at :datetime
#  provider          :string           not null
#  validation_status :string           default("unknown"), not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  account_id        :bigint           not null
#
# Indexes
#
#  index_atende_llm_credentials_on_account_id_and_provider  (account_id,provider)
#  index_atende_llm_credentials_one_default_per_account     (account_id,is_default) UNIQUE WHERE (is_default = true)
#
# Foreign Keys
#
#  fk_rails_...  (account_id => accounts.id) ON DELETE => cascade
#
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
