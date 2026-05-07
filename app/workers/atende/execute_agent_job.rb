module Atende
  class ExecuteAgentJob < ApplicationJob
    queue_as :default

    def perform(session_id, message_content)
      session = Atende::Session.find_by(id: session_id)
      return unless session&.active?

      Atende::AgentRunner.new(session).run(message_content)
    end
  end
end
