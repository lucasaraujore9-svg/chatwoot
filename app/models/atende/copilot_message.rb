# == Schema Information
#
# Table name: atende_copilot_messages
#
#  id                :bigint           not null, primary key
#  completion_tokens :integer
#  content           :text
#  llm_model         :string
#  llm_provider      :string
#  prompt_tokens     :integer
#  role              :string           not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  account_id        :bigint           not null
#  thread_id         :bigint           not null
#
# Indexes
#
#  index_atende_copilot_messages_on_account_id                (account_id)
#  index_atende_copilot_messages_on_thread_id_and_created_at  (thread_id,created_at)
#
# Foreign Keys
#
#  fk_rails_...  (account_id => accounts.id) ON DELETE => cascade
#  fk_rails_...  (thread_id => atende_copilot_threads.id) ON DELETE => cascade
#
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
