# == Schema Information
#
# Table name: atende_agents
#
#  id                :bigint           not null, primary key
#  description       :text
#  dynamic_config    :jsonb
#  history_limit     :integer          default(20)
#  is_active         :boolean          default(TRUE), not null
#  max_tokens        :integer          default(1000)
#  model             :string           not null
#  name              :string           not null
#  notify_mode       :string
#  notify_template   :text
#  pause_label       :string
#  routing_strategy  :string
#  system_prompt     :text
#  temperature       :decimal(3, 2)    default(0.7)
#  tools_config      :jsonb
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  account_id        :bigint           not null
#  llm_credential_id :bigint           not null
#  routing_agent_id  :bigint
#  routing_team_id   :bigint
#
# Indexes
#
#  index_atende_agents_on_account_id_and_is_active  (account_id,is_active)
#
# Foreign Keys
#
#  fk_rails_...  (account_id => accounts.id) ON DELETE => cascade
#  fk_rails_...  (llm_credential_id => atende_llm_credentials.id) ON DELETE => restrict
#
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
