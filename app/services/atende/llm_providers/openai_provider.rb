module Atende
  module LlmProviders
    class OpenaiProvider < BaseProvider
      BASE_URL = 'https://api.openai.com/v1'.freeze

      def chat(messages, tools_schema: [])
        conn = Faraday.new(url: BASE_URL) do |f|
          f.request :json
          f.response :json
          f.options.timeout = 60
          f.adapter Faraday.default_adapter
        end

        body = {
          model: agent.model,
          messages: messages,
          temperature: agent.temperature&.to_f || 0.7,
          max_tokens: agent.max_tokens || 2048
        }
        body[:tools] = tools_schema.map { |t| { type: 'function', function: t } } if tools_schema.any?

        response = conn.post('/v1/chat/completions', body.to_json, {
                               'Authorization' => "Bearer #{api_key}",
                               'Content-Type' => 'application/json'
                             })

        raise "OpenAI error: #{response.body['error']&.dig('message')}" if response.status != 200

        choice = response.body.dig('choices', 0, 'message')
        {
          content: choice['content'],
          tool_calls: choice['tool_calls'],
          finish_reason: response.body.dig('choices', 0, 'finish_reason'),
          token_usage: response.body['usage'] || {}
        }
      end
    end
  end
end
