module Atende
  class ExecuteFlowJob < ApplicationJob
    queue_as :default

    def perform(session_id, incoming_message_content = nil)
      session = Atende::Session.find_by(id: session_id)
      return unless session&.active?

      Atende::FlowExecutor.new(session).resume(incoming_message_content)
    end
  end
end
