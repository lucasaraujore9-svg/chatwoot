# == Schema Information
#
# Table name: atende_sla_policies
#
#  id                            :bigint           not null, primary key
#  business_hours_only           :boolean          default(FALSE), not null
#  conditions                    :jsonb
#  description                   :text
#  first_response_time_threshold :integer
#  is_active                     :boolean          default(TRUE), not null
#  name                          :string           not null
#  next_response_time_threshold  :integer
#  resolution_time_threshold     :integer
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#  account_id                    :bigint           not null
#
# Indexes
#
#  index_atende_sla_policies_on_account_id  (account_id)
#
# Foreign Keys
#
#  fk_rails_...  (account_id => accounts.id) ON DELETE => cascade
#
module Atende
  class SlaPolicy < ApplicationRecord
    self.table_name = 'atende_sla_policies'

    belongs_to :account

    validates :account_id, :name, presence: true
    validates :name, uniqueness: { scope: :account_id }

    scope :active, -> { where(is_active: true) }
    scope :for_account, ->(account_id) { where(account_id: account_id) }
  end
end
