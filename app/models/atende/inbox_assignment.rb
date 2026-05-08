# == Schema Information
#
# Table name: atende_inbox_assignments
#
#  id         :bigint           not null, primary key
#  is_active  :boolean          default(TRUE), not null
#  kind       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  account_id :bigint           not null
#  agent_id   :bigint
#  flow_id    :bigint
#  inbox_id   :bigint           not null
#
# Indexes
#
#  index_atende_inbox_assignments_on_account_id         (account_id)
#  index_atende_inbox_assignments_one_active_per_inbox  (inbox_id,is_active) UNIQUE WHERE (is_active = true)
#
# Foreign Keys
#
#  fk_rails_...  (account_id => accounts.id) ON DELETE => cascade
#  fk_rails_...  (flow_id => atende_flows.id) ON DELETE => cascade
#  fk_rails_...  (inbox_id => inboxes.id) ON DELETE => cascade
#
module Atende
  class InboxAssignment < ApplicationRecord
    self.table_name = 'atende_inbox_assignments'

    belongs_to :account
    belongs_to :inbox
    belongs_to :flow, class_name: 'Atende::Flow', optional: true

    validates :account_id, :inbox_id, :kind, presence: true
    validates :inbox_id, uniqueness: { scope: :is_active, conditions: -> { where(is_active: true) }, message: 'already has an active assignment' }
    validates :kind, inclusion: { in: %w[flow agent] }
    validate :flow_or_agent_present

    scope :active, -> { where(is_active: true) }
    scope :for_account, ->(account_id) { where(account_id: account_id) }
    scope :active_for_inbox, ->(inbox_id) { active.find_by(inbox_id: inbox_id) }

    private

    def flow_or_agent_present
      return if flow_id.present? || agent_id.present?

      errors.add(:base, 'must have either a flow or agent assigned')
    end
  end
end
