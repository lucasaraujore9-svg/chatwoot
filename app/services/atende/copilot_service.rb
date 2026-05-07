module Atende
  class CopilotService
    MAX_HISTORY = 20

    def initialize(thread)
      @thread = thread
      @account = thread.account
      @conversation = thread.conversation
    end

    def suggest(user_message)
      persist_user_message(user_message)
      broadcast_typing

      agent = find_agent
      return broadcast_error('no_agent') unless agent

      provider = Atende::LlmProviders::Factory.build(agent)
      messages = build_messages(user_message)

      response = provider.chat(messages)
      reply = response[:content].to_s.strip

      persist_assistant_message(reply)
      broadcast_message(reply)
      reply
    rescue StandardError => e
      Rails.logger.error "[Atende::CopilotService] #{e.class}: #{e.message}"
      broadcast_error('llm_error')
      nil
    end

    private

    def find_agent
      Atende::InboxAssignment
        .active_for_inbox(@conversation.inbox_id)
        &.assignable_resource
        &.then { |r| r.is_a?(Atende::Agent) ? r : nil }
    end

    def build_messages(_user_message)
      history = @thread.atende_copilot_messages.order(created_at: :asc).last(MAX_HISTORY)
      system_prompt = build_system_prompt

      messages = [{ role: 'system', content: system_prompt }]
      history.each do |msg|
        messages << { role: msg.role, content: msg.content }
      end
      messages
    end

    def build_system_prompt
      [
        'Você é um copiloto de IA auxiliando um atendente humano.',
        'Analise a conversa e sugira respostas adequadas para o atendente enviar ao cliente.',
        'Seja conciso, profissional e direto.',
        conversation_context
      ].compact.join("\n\n")
    end

    def conversation_context
      msgs = @conversation.messages
                          .where(message_type: [0, 1])
                          .order(created_at: :desc)
                          .limit(10)
                          .reverse
      return nil if msgs.empty?

      lines = msgs.map do |m|
        sender = m.message_type == 0 ? 'Cliente' : 'Atendente'
        "#{sender}: #{m.content}"
      end
      "Contexto da conversa:\n#{lines.join("\n")}"
    end

    def persist_user_message(content)
      @thread.atende_copilot_messages.create!(
        account: @account,
        role: 'user',
        content: content
      )
    end

    def persist_assistant_message(content)
      @thread.atende_copilot_messages.create!(
        account: @account,
        role: 'assistant',
        content: content
      )
    end

    def broadcast_typing
      ActionCable.server.broadcast(
        "atende_copilot_thread_#{@thread.id}",
        { type: 'typing', thread_id: @thread.id }
      )
    end

    def broadcast_message(content)
      ActionCable.server.broadcast(
        "atende_copilot_thread_#{@thread.id}",
        {
          type: 'message',
          thread_id: @thread.id,
          role: 'assistant',
          content: content
        }
      )
    end

    def broadcast_error(code)
      ActionCable.server.broadcast(
        "atende_copilot_thread_#{@thread.id}",
        { type: 'error', code: code }
      )
    end
  end
end
