module Atende
  class CopilotMessage < ApplicationRecord
    self.table_name = 'atende_copilot_messages'

    belongs_to :thread, class_name: 'Atende::CopilotThread'
    belongs_to :account

    ROLES = %w[user assistant].freeze
    validates :thread_id, :account_id, :role, :content, presence: true
    validates :role, inclusion: { in: ROLES }
  end
end
