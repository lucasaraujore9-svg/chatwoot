module Atende
  class AgentMessage < ApplicationRecord
    self.table_name = 'atende_agent_messages'

    belongs_to :session, class_name: 'Atende::Session'

    ROLES = %w[system user assistant tool].freeze

    validates :session_id, :role, presence: true
    validates :role, inclusion: { in: ROLES }
  end
end
