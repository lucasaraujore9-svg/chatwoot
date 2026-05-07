module Atende
  class CheckSlaViolationsJob < ApplicationJob
    queue_as :scheduled

    def perform
      now = Time.current
      Atende::AppliedSla.joins(:sla_policy)
                        .where(breached_at: nil)
                        .where.not(first_response_deadline: nil)
                        .find_each do |applied|
        check_and_mark_breach(applied, now)
      end
    end

    private

    def check_and_mark_breach(applied, now)
      conversation = applied.conversation
      return unless conversation

      breached = false

      if applied.first_response_deadline.present? && now > applied.first_response_deadline && !conversation.messages.outgoing.exists?
        breached = true
        Atende::SlaEvent.find_or_create_by!(
          applied_sla: applied,
          event_type: 'first_response_breached'
        ) { |e| e.occurred_at = now }
      end

      if applied.resolution_deadline.present? && now > applied.resolution_deadline && !conversation.resolved?
        breached = true
        Atende::SlaEvent.find_or_create_by!(
          applied_sla: applied,
          event_type: 'resolution_breached'
        ) { |e| e.occurred_at = now }
      end

      applied.update!(breached_at: now) if breached && applied.breached_at.nil?
    end
  end
end
