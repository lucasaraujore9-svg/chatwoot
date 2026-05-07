module Atende
  class AppliedSla < ApplicationRecord
    self.table_name = 'atende_applied_slas'

    belongs_to :account
    belongs_to :conversation
    belongs_to :sla_policy, class_name: 'Atende::SlaPolicy'
    has_many :sla_events, class_name: 'Atende::SlaEvent', dependent: :destroy

    validates :account_id, :conversation_id, :sla_policy_id, presence: true
    validates :conversation_id, uniqueness: { scope: :sla_policy_id }
  end
end
