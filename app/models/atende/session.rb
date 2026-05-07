module Atende
  class Session < ApplicationRecord
    self.table_name = 'atende_sessions'

    belongs_to :account
    belongs_to :conversation
    belongs_to :contact
    belongs_to :flow, class_name: 'Atende::Flow', optional: true
    belongs_to :agent, class_name: 'Atende::Agent', optional: true
    has_many :node_runs, class_name: 'Atende::NodeRun', dependent: :destroy
    has_many :agent_messages, class_name: 'Atende::AgentMessage', dependent: :destroy

    enum :status, { active: 'active', completed: 'completed', failed: 'failed', expired: 'expired' }, default: :active
    enum :kind, { flow: 'flow', agent: 'agent' }

    validates :account_id, :conversation_id, :contact_id, :kind, presence: true
    validates :conversation_id, uniqueness: { scope: :status, conditions: -> { where(status: 'active') }, message: 'already has an active session' }

    scope :for_account, ->(account_id) { where(account_id: account_id) }
    scope :active, -> { where(status: :active) }
  end
end
