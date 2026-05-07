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
