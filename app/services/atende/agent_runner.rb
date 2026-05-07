module Atende
  class AgentRunner
    MAX_TOOL_ITERATIONS = 10

    ALL_TOOLS = [
      Atende::AgentTools::EncaminharAtendimento,
      Atende::AgentTools::AdicionarLabel,
      Atende::AgentTools::TransferirTime,
      Atende::AgentTools::AtualizarAtributoContato,
      Atende::AgentTools::AtualizarAtributoConversa,
      Atende::AgentTools::SalvarVariavel,
      Atende::AgentTools::FinalizarAtendimento
    ].freeze

    def initialize(session)
      @session = session
      @agent = session.agent
    end

    def run(user_message_content)
      return unless @session.active?

      append_message(:user, user_message_content)
      agentic_loop
    rescue StandardError => e
      Rails.logger.error "[Atende::AgentRunner] session=#{@session.id} error=#{e.message}"
      @session.update!(status: :failed)
      raise
    end

    private

    def agentic_loop
      max_iter = max_tool_iterations
      iter = 0

      loop do
        iter += 1
        raise "Max tool iterations (#{max_iter}) exceeded for agent session #{@session.id}" if iter > max_iter

        provider = Atende::LlmProviders::Factory.build(@agent)
        messages = build_messages_for_llm
        tools_schema = enabled_tools.map(&:schema)

        response = provider.chat(messages, tools_schema: tools_schema)

        persist_message(:assistant, response[:content], tool_calls: response[:tool_calls],
                                                        token_usage: response[:token_usage])

        break if response[:tool_calls].blank?
        break unless @session.reload.active?

        process_tool_calls(response[:tool_calls])

        break unless @session.reload.active?
      end

      send_reply_to_conversation
    end

    def build_messages_for_llm
      history_limit = @agent.history_limit || 20
      msgs = []
      msgs << { role: 'system', content: @agent.system_prompt } if @agent.system_prompt.present?
      msgs += @session.agent_messages.order(:created_at).last(history_limit).map do |m|
        base = { role: m.role, content: m.content }
        base[:tool_calls] = m.tool_calls if m.tool_calls.present?
        base[:tool_call_id] = m.tool_call_id if m.tool_call_id.present?
        base[:name] = m.tool_name if m.tool_name.present?
        base
      end
      msgs
    end

    def process_tool_calls(tool_calls)
      tool_calls.each do |tc|
        tool_name = tc.dig('function', 'name')
        args = begin
          JSON.parse(tc.dig('function', 'arguments') || '{}')
        rescue StandardError
          {}
        end
        tool_class = enabled_tools.find { |t| t.schema[:name] == tool_name }
        result = tool_class ? tool_class.new(@session).call(args) : { error: "Unknown tool: #{tool_name}" }

        persist_message(:tool, result.to_json,
                        tool_call_id: tc['id'],
                        tool_name: tool_name)
      end
    end

    def send_reply_to_conversation
      last_assistant = @session.agent_messages.where(role: 'assistant').order(:created_at).last
      return unless last_assistant&.content.present?

      Messages::MessageBuilder.new(nil, @session.conversation, {
                                     content: last_assistant.content,
                                     message_type: :outgoing,
                                     content_type: :text,
                                     private: false
                                   }).perform
    end

    def append_message(role, content)
      persist_message(role, content)
    end

    def persist_message(role, content, tool_calls: nil, tool_call_id: nil, tool_name: nil, token_usage: nil)
      Atende::AgentMessage.create!(
        session_id: @session.id,
        role: role.to_s,
        content: content,
        tool_calls: tool_calls,
        tool_call_id: tool_call_id,
        tool_name: tool_name,
        prompt_tokens: token_usage&.dig('prompt_tokens') || token_usage&.dig('input_tokens'),
        completion_tokens: token_usage&.dig('completion_tokens') || token_usage&.dig('output_tokens')
      )
    end

    def enabled_tools
      tools_config = @agent.tools_config || []
      return ALL_TOOLS if tools_config.empty?

      ALL_TOOLS.select { |t| tools_config.include?(t.schema[:name]) }
    end

    def max_tool_iterations
      config = InstallationConfig.find_by(name: 'ATENDE_AGENT_MAX_TOOL_ITERATIONS')&.value&.to_i
      config&.positive? ? config : MAX_TOOL_ITERATIONS
    end
  end
end
