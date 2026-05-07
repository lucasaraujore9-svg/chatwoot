module Atende
  module LlmProviders
    class AnthropicProvider < BaseProvider
      BASE_URL = 'https://api.anthropic.com'.freeze
      API_VERSION = '2023-06-01'.freeze

      def chat(messages, tools_schema: [])
        conn = Faraday.new(url: BASE_URL) do |f|
          f.request :json
          f.response :json
          f.options.timeout = 60
          f.adapter Faraday.default_adapter
        end

        system_prompt = agent.system_prompt.presence
        anthropic_messages = convert_messages(messages)

        body = {
          model: agent.model,
          max_tokens: agent.max_tokens || 2048,
          messages: anthropic_messages
        }
        body[:system] = system_prompt if system_prompt
        body[:tools] = tools_schema.map { |t| { name: t[:name], description: t[:description], input_schema: t[:parameters] } } if tools_schema.any?

        response = conn.post('/v1/messages', body.to_json, {
                               'x-api-key' => api_key,
                               'anthropic-version' => API_VERSION,
                               'Content-Type' => 'application/json'
                             })

        raise "Anthropic error: #{response.body['error']&.dig('message')}" if response.status != 200

        content_blocks = response.body['content'] || []
        text_block = content_blocks.find { |b| b['type'] == 'text' }
        tool_use_blocks = content_blocks.select { |b| b['type'] == 'tool_use' }

        tool_calls = tool_use_blocks.map do |b|
          { 'id' => b['id'], 'type' => 'function', 'function' => { 'name' => b['name'], 'arguments' => b['input'].to_json } }
        end

        {
          content: text_block&.dig('text'),
          tool_calls: tool_calls.presence,
          finish_reason: response.body['stop_reason'],
          token_usage: response.body['usage'] || {}
        }
      end

      private

      def convert_messages(messages)
        messages.filter_map do |m|
          role = m[:role] || m['role']
          content = m[:content] || m['content']
          next if role == 'system'

          { role: role == 'tool' ? 'user' : role, content: content.to_s }
        end
      end
    end
  end
end
