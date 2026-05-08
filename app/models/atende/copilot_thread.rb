# == Schema Information
#
# Table name: atende_copilot_threads
#
#  id              :bigint           not null, primary key
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  account_id      :bigint           not null
#  conversation_id :bigint           not null
#  user_id         :bigint           not null
#
# Indexes
#
#  index_atende_copilot_threads_on_conversation_id_and_user_id  (conversation_id,user_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (account_id => accounts.id) ON DELETE => cascade
#  fk_rails_...  (conversation_id => conversations.id) ON DELETE => cascade
#  fk_rails_...  (user_id => users.id) ON DELETE => cascade
#
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
