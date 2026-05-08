# == Schema Information
#
# Table name: atende_applied_slas
#
#  id                :bigint           not null, primary key
#  first_response_at :datetime
#  resolved_at       :datetime
#  sla_status        :string           default("active"), not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  account_id        :bigint           not null
#  conversation_id   :bigint           not null
#  sla_policy_id     :bigint           not null
#
# Indexes
#
#  index_atende_applied_slas_on_account_id                    (account_id)
#  index_atende_applied_slas_on_conversation_id               (conversation_id)
#  index_atende_applied_slas_on_sla_policy_id_and_sla_status  (sla_policy_id,sla_status)
#
# Foreign Keys
#
#  fk_rails_...  (account_id => accounts.id) ON DELETE => cascade
#  fk_rails_...  (conversation_id => conversations.id) ON DELETE => cascade
#  fk_rails_...  (sla_policy_id => atende_sla_policies.id) ON DELETE => cascade
#
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
