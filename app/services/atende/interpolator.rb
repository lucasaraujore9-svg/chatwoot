module Atende
  class Interpolator
    PATTERN = /\{\{([a-zA-Z0-9_.]+)\}\}/

    def initialize(variables = {})
      @variables = variables.with_indifferent_access
    end

    def interpolate(text)
      return text unless text.is_a?(String)

      text.gsub(PATTERN) do |_match|
        key = ::Regexp.last_match(1)
        resolve(key)
      end
    end

    private

    def resolve(key)
      parts = key.split('.')
      value = @variables
      parts.each do |part|
        value = value.is_a?(Hash) ? value[part] : nil
        break if value.nil?
      end
      value.to_s
    end
  end
end
