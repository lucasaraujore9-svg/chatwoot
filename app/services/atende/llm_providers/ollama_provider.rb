module Atende
  module LlmProviders
    class OllamaProvider < BaseProvider
      def chat(messages, tools_schema: [])
        extra = credential.extra_config || {}
        base_url = extra['base_url'].presence || 'http://localhost:11434'

        conn = Faraday.new(url: base_url) do |f|
          f.request :json
          f.response :json
          f.options.timeout = 120
          f.adapter Faraday.default_adapter
        end

        body = {
          model: agent.model || 'llama3.3',
          messages: messages.map { |m| { role: m[:role] || m['role'], content: m[:content] || m['content'] } },
          stream: false,
          options: { temperature: agent.temperature&.to_f || 0.7, num_predict: agent.max_tokens || 2048 }
        }
        body[:tools] = tools_schema.map { |t| { type: 'function', function: t } } if tools_schema.any?

        response = conn.post('/api/chat', body)
        raise "Ollama error: #{response.body}" if response.status != 200

        message = response.body['message'] || {}
        {
          content: message['content'],
          tool_calls: message['tool_calls'],
          finish_reason: response.body['done'] ? 'stop' : nil,
          token_usage: {}
        }
      end
    end
  end
end
