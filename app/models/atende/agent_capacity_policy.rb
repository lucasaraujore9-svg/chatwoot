# == Schema Information
#
# Table name: atende_agent_capacity_policies
#
#  id                 :bigint           not null, primary key
#  conversation_limit :integer          not null
#  inbox_limits       :jsonb
#  is_active          :boolean          default(TRUE), not null
#  max_conversations  :integer
#  name               :string           not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  account_id         :bigint           not null
#  agent_id           :bigint
#
# Indexes
#
#  idx_atende_capacity_policies_account_agent          (account_id,agent_id) UNIQUE
#  index_atende_agent_capacity_policies_on_account_id  (account_id)
#  index_atende_agent_capacity_policies_on_agent_id    (agent_id)
#
# Foreign Keys
#
#  fk_rails_...  (account_id => accounts.id) ON DELETE => cascade
#  fk_rails_...  (agent_id => users.id) ON DELETE => cascade
#
module Atende
  class AgentCapacityPolicy < ApplicationRecord
    self.table_name = 'atende_agent_capacity_policies'

    belongs_to :account
    belongs_to :agent, class_name: '::User'

    validates :account_id, :agent_id, :max_conversations, presence: true
    validates :max_conversations, numericality: { greater_than: 0, less_than_or_equal_to: 1000 }
    validates :agent_id, uniqueness: { scope: :account_id }

    scope :active, -> { where(is_active: true) }
    scope :for_account, ->(account_id) { where(account_id: account_id) }
  end
end
