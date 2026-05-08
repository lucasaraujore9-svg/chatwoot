# == Schema Information
#
# Table name: atende_flows
#
#  id           :bigint           not null, primary key
#  description  :text
#  graph        :jsonb
#  is_published :boolean          default(FALSE), not null
#  name         :string           not null
#  status       :string           default("draft"), not null
#  version      :integer          default(1), not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  account_id   :bigint           not null
#
# Indexes
#
#  index_atende_flows_on_account_id_and_is_published  (account_id,is_published)
#  index_atende_flows_on_account_id_and_status        (account_id,status)
#
# Foreign Keys
#
#  fk_rails_...  (account_id => accounts.id) ON DELETE => cascade
#
module Atende
  class Flow < ApplicationRecord
    self.table_name = 'atende_flows'

    belongs_to :account

    enum :status, { draft: 'draft', published: 'published', paused: 'paused' }, default: :draft

    validates :name, presence: true, length: { maximum: 255 }
    validates :account_id, presence: true
    validate :graph_is_valid_json

    scope :by_account, ->(account_id) { where(account_id: account_id) }
    scope :active, -> { where(status: :published) }

    before_update :increment_version, if: :graph_changed?

    private

    def graph_is_valid_json
      return if graph.is_a?(Hash)

      errors.add(:graph, 'must be a valid JSON object')
    end

    def increment_version
      self.version = (version || 1) + 1
    end
  end
end
