# == Schema Information
#
# Table name: atende_sessions
#
#  id               :bigint           not null, primary key
#  ended_at         :datetime
#  kind             :string           not null
#  last_activity_at :datetime
#  started_at       :datetime
#  status           :string           default("active"), not null
#  variables        :jsonb
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  account_id       :bigint           not null
#  agent_id         :bigint
#  contact_id       :bigint           not null
#  conversation_id  :bigint           not null
#  current_node_id  :string
#  flow_id          :bigint
#
# Indexes
#
#  idx_atende_sessions_account_status_activity        (account_id,status,last_activity_at)
#  index_atende_sessions_on_conversation_id           (conversation_id)
#  index_atende_sessions_one_active_per_conversation  (conversation_id,status) UNIQUE WHERE ((status)::text = 'active'::text)
#
# Foreign Keys
#
#  fk_rails_...  (account_id => accounts.id) ON DELETE => cascade
#  fk_rails_...  (agent_id => atende_agents.id) ON DELETE => nullify
#  fk_rails_...  (contact_id => contacts.id) ON DELETE => cascade
#  fk_rails_...  (conversation_id => conversations.id) ON DELETE => cascade
#  fk_rails_...  (flow_id => atende_flows.id) ON DELETE => nullify
#
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
