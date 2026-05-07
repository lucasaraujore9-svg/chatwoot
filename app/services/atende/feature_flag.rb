module Atende
  class FeatureFlag
    FEATURES = %w[atende_flows atende_agents qrcode_whatsapp].freeze
    CACHE_TTL = 5.minutes

    def self.enabled?(feature, _account = nil)
      return false unless FEATURES.include?(feature.to_s)

      Rails.cache.fetch("atende_feature_flag:#{feature}", expires_in: CACHE_TTL) do
        config = InstallationConfig.find_by(name: feature.to_s.upcase)
        config ? ActiveModel::Type::Boolean.new.cast(config.value) : true
      end
    end

    def self.flows_enabled?(account = nil)
      enabled?(:atende_flows, account)
    end

    def self.agents_enabled?(account = nil)
      enabled?(:atende_agents, account)
    end

    def self.qrcode_whatsapp_enabled?(account = nil)
      enabled?(:qrcode_whatsapp, account)
    end
  end
end
