module Atende
  class ExpireSessionsJob < ApplicationJob
    queue_as :scheduled

    def perform
      ttl_hours = InstallationConfig.find_by(name: 'ATENDE_FLOW_SESSION_TTL_HOURS')&.value&.to_i || 24
      cutoff = ttl_hours.hours.ago

      Atende::Session.active.where('updated_at < ?', cutoff).find_each do |session|
        session.update!(status: :expired)
      end
    end
  end
end
