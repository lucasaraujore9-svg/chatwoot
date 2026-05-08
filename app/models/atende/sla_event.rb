# == Schema Information
#
# Table name: atende_sla_events
#
#  id             :bigint           not null, primary key
#  event_type     :string           not null
#  occurred_at    :datetime         not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  applied_sla_id :bigint           not null
#
# Indexes
#
#  index_atende_sla_events_on_applied_sla_id_and_event_type  (applied_sla_id,event_type)
#
# Foreign Keys
#
#  fk_rails_...  (applied_sla_id => atende_applied_slas.id) ON DELETE => cascade
#
module Atende
  class SlaEvent < ApplicationRecord
    self.table_name = 'atende_sla_events'

    belongs_to :applied_sla, class_name: 'Atende::AppliedSla'

    EVENT_TYPES = %w[first_response_breached next_response_breached resolution_breached first_response_met resolution_met].freeze
    validates :applied_sla_id, :event_type, :occurred_at, presence: true
    validates :event_type, inclusion: { in: EVENT_TYPES }
  end
end
