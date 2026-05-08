# == Schema Information
#
# Table name: atende_agent_messages
#
#  id                :bigint           not null, primary key
#  completion_tokens :integer
#  content           :text
#  prompt_tokens     :integer
#  role              :string           not null
#  tool_calls        :jsonb
#  tool_name         :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  session_id        :bigint           not null
#  tool_call_id      :string
#
# Indexes
#
#  index_atende_agent_messages_on_session_id_and_created_at  (session_id,created_at)
#
# Foreign Keys
#
#  fk_rails_...  (session_id => atende_sessions.id) ON DELETE => cascade
#
module Atende
  class AgentMessage < ApplicationRecord
    self.table_name = 'atende_agent_messages'

    belongs_to :session, class_name: 'Atende::Session'

    ROLES = %w[system user assistant tool].freeze

    validates :session_id, :role, presence: true
    validates :role, inclusion: { in: ROLES }
  end
end
