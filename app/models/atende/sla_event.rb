module Atende
  class SlaEvent < ApplicationRecord
    self.table_name = 'atende_sla_events'

    belongs_to :applied_sla, class_name: 'Atende::AppliedSla'

    EVENT_TYPES = %w[first_response_breached next_response_breached resolution_breached first_response_met resolution_met].freeze
    validates :applied_sla_id, :event_type, :occurred_at, presence: true
    validates :event_type, inclusion: { in: EVENT_TYPES }
  end
end
