module Atende
  class CopilotThread < ApplicationRecord
    self.table_name = 'atende_copilot_threads'

    belongs_to :account
    belongs_to :conversation
    has_many :atende_copilot_messages, class_name: 'Atende::CopilotMessage', foreign_key: :thread_id, dependent: :destroy

    validates :account_id, :conversation_id, presence: true
    validates :conversation_id, uniqueness: { scope: :account_id }
  end
end
