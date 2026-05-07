class InstallAtendeAgentSettings < ActiveRecord::Migration[7.0]
  SETTINGS = [
    { name: 'ATENDE_AGENTS_ENABLED', value: true },
    { name: 'ATENDE_DEFAULT_PROVIDER', value: 'openai' },
    { name: 'ATENDE_ALLOWED_PROVIDERS', value: %w[openai anthropic google ollama] },
    { name: 'ATENDE_AGENT_MAX_TOOL_ITERATIONS', value: 6 }
  ].freeze

  def up
    SETTINGS.each do |setting|
      InstallationConfig.find_or_create_by(name: setting[:name]) do |config|
        config.value = setting[:value]
        config.locked = false
      end
    end
  end

  def down
    SETTINGS.each { |s| InstallationConfig.find_by(name: s[:name])&.destroy }
  end
end
