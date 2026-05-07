class InstallAtendeSettings < ActiveRecord::Migration[7.0]
  SETTINGS = [
    { name: 'ATENDE_ENABLED', value: true },
    { name: 'ATENDE_FLOWS_ENABLED', value: true },
    { name: 'ATENDE_FLOW_SESSION_TTL_HOURS', value: 24 }
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
