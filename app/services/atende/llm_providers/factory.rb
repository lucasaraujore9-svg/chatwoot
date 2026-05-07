module Atende
  module LlmProviders
    class Factory
      PROVIDERS = {
        'openai' => Atende::LlmProviders::OpenaiProvider,
        'anthropic' => Atende::LlmProviders::AnthropicProvider,
        'google' => Atende::LlmProviders::GoogleProvider,
        'ollama' => Atende::LlmProviders::OllamaProvider
      }.freeze

      def self.build(agent)
        credential = agent.llm_credential
        raise ArgumentError, 'Agent has no LLM credential' unless credential

        provider_class = PROVIDERS[credential.provider.to_s]
        raise ArgumentError, "Unknown provider: #{credential.provider}" unless provider_class

        provider_class.new(credential, agent)
      end
    end
  end
end
