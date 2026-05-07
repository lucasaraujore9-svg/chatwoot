module Atende
  class CopilotJob < ApplicationJob
    queue_as :default

    def perform(thread_id:, account_id:, user_message:)
      thread = Atende::CopilotThread.find_by(id: thread_id, account_id: account_id)
      return unless thread

      Atende::CopilotService.new(thread).suggest(user_message)
    end
  end
end
