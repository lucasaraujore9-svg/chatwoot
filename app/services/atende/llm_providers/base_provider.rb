module Atende
  module LlmProviders
    class BaseProvider
      attr_reader :credential, :agent

      def initialize(credential, agent)
        @credential = credential
        @agent = agent
      end

      # messages: [{ role: 'user'|'assistant'|'tool', content: String, tool_calls: [], tool_call_id: }]
      # tools_schema: [{ name:, description:, parameters: {} }]
      # Returns: { content: String, tool_calls: [] | nil, finish_reason: String, token_usage: {} }
      def chat(messages, tools_schema: [])
        raise NotImplementedError
      end

      protected

      def api_key
        decrypt(credential.api_key_encrypted)
      end

      def decrypt(encrypted)
        encryptor.decrypt_and_verify(encrypted)
      rescue ActiveSupport::MessageEncryptor::InvalidMessage
        raise ArgumentError, "Failed to decrypt credential for provider #{credential.provider}"
      end

      def encryptor
        @encryptor ||= ActiveSupport::MessageEncryptor.new(
          Rails.application.secret_key_base[0..31]
        )
      end
    end
  end
end
