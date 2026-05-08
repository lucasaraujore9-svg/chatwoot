# Atende·AI — Default branding seed
# Runs after DB is ready. Sets Atende·AI branding in InstallationConfig
# only if the value is still the Chatwoot default or blank.
# Safe to run on every boot — uses first_or_create with conditional update.
Rails.application.config.after_initialize do
  next unless defined?(InstallationConfig) && ActiveRecord::Base.connection.table_exists?('installation_configs')

  ATENDE_BRANDING = {
    'INSTALLATION_NAME' => 'Atende·AI',
    'BRAND_NAME'        => 'Atende·AI',
  }.freeze

  ATENDE_BRANDING.each do |key, value|
    record = InstallationConfig.find_by(name: key)

    if record.nil?
      InstallationConfig.create!(name: key, value: value, locked: false)
    elsif record.value.blank? || record.value == 'Chatwoot'
      record.update!(value: value)
    end
  end

  GlobalConfig.clear_cache
rescue StandardError => e
  Rails.logger.warn "[Atende Branding] Could not seed branding: #{e.message}"
end
