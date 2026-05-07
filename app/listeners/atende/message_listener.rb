module Atende
  class MessageListener < BaseListener
    def message_created(event)
      message = event.data[:message]
      return if skip_message?(message)

      conversation = message.conversation
      account = message.account

      active_session = Atende::Session.active.find_by(conversation_id: conversation.id)

      if active_session
        if active_session.flow?
          Atende::ExecuteFlowJob.perform_later(active_session.id, message.content)
        elsif active_session.agent?
          Atende::ExecuteAgentJob.perform_later(active_session.id, message.content)
        end
        return
      end

      assignment = Atende::InboxAssignment.active_for_inbox(conversation.inbox_id)
      return unless assignment

      if assignment.flow? && assignment.flow_id.present?
        flow = Atende::Flow.find_by(id: assignment.flow_id, account_id: account.id)
        return unless flow&.published?

        session = Atende::Session.create!(
          account: account,
          conversation: conversation,
          contact: conversation.contact,
          flow: flow,
          kind: :flow,
          status: :active,
          variables: {}
        )
        Atende::FlowExecutor.start(session)
      elsif assignment.agent? && assignment.agent_id.present?
        agent = Atende::Agent.find_by(id: assignment.agent_id, account_id: account.id)
        return unless agent&.is_active?

        session = Atende::Session.create!(
          account: account,
          conversation: conversation,
          contact: conversation.contact,
          agent: agent,
          kind: :agent,
          status: :active,
          variables: {}
        )
        Atende::ExecuteAgentJob.perform_later(session.id, message.content)
      end
    rescue StandardError => e
      Rails.logger.error "[Atende::MessageListener] error=#{e.message} conversation_id=#{event.data.dig(:message, :conversation_id)}"
    end

    private

    def skip_message?(message)
      return true if message.outgoing?
      return true if message.activity?
      return true if message.content.blank?

      false
    end
  end
end
