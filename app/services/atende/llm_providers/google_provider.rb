module Atende
  module LlmProviders
    class GoogleProvider < BaseProvider
      BASE_URL = 'https://generativelanguage.googleapis.com/v1beta'.freeze

      def chat(messages, tools_schema: [])
        conn = Faraday.new(url: BASE_URL) do |f|
          f.request :json
          f.response :json
          f.options.timeout = 60
          f.adapter Faraday.default_adapter
        end

        contents = messages.filter_map do |m|
          role = (m[:role] || m['role']).to_s
          content = (m[:content] || m['content']).to_s
          next if role == 'system'

          gemini_role = role == 'assistant' ? 'model' : 'user'
          { role: gemini_role, parts: [{ text: content }] }
        end

        body = { contents: contents, generationConfig: { temperature: agent.temperature&.to_f || 0.7, maxOutputTokens: agent.max_tokens || 2048 } }

        if tools_schema.any?
          body[:tools] = [{ functionDeclarations: tools_schema.map do |t|
            { name: t[:name], description: t[:description], parameters: t[:parameters] }
          end }]
        end

        model = agent.model || 'gemini-2.0-flash'
        response = conn.post("/models/#{model}:generateContent?key=#{api_key}", body)

        raise "Google error: #{response.body['error']&.dig('message')}" if response.status != 200

        candidate = response.body.dig('candidates', 0, 'content', 'parts', 0)
        {
          content: candidate&.dig('text'),
          tool_calls: nil,
          finish_reason: response.body.dig('candidates', 0, 'finishReason'),
          token_usage: response.body['usageMetadata'] || {}
        }
      end
    end
  end
end
