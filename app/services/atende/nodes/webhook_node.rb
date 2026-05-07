module Atende
  module Nodes
    class WebhookNode < BaseNode
      ALLOWED_METHODS = %w[GET POST PUT PATCH].freeze
      TIMEOUT = 10
      PRIVATE_RANGES = [
        IPAddr.new('10.0.0.0/8'),
        IPAddr.new('172.16.0.0/12'),
        IPAddr.new('192.168.0.0/16'),
        IPAddr.new('127.0.0.0/8'),
        IPAddr.new('169.254.0.0/16'),
        IPAddr.new('::1/128'),
        IPAddr.new('fc00::/7')
      ].freeze

      def execute
        url = interp(data['url'].to_s)
        method = (data['method'] || 'POST').upcase
        headers = build_headers
        body = build_body

        raise ArgumentError, 'Webhook URL is not allowed (SSRF guard)' if blocked_url?(url)
        raise ArgumentError, "HTTP method #{method} not allowed" unless ALLOWED_METHODS.include?(method)

        response = make_request(url, method, headers, body)
        handle_response(response)
      end

      private

      def blocked_url?(url)
        uri = URI.parse(url)
        return true unless %w[http https].include?(uri.scheme)

        host = uri.host
        return true if host.blank?

        addresses = Resolv.getaddresses(host)
        return true if addresses.empty?

        addresses.any? do |addr|
          ip = IPAddr.new(addr)
          PRIVATE_RANGES.any? { |range| range.include?(ip) }
        rescue IPAddr::InvalidAddressError
          true
        end
      rescue URI::InvalidURIError, Resolv::ResolvError
        true
      end

      def build_headers
        base = { 'Content-Type' => 'application/json', 'User-Agent' => 'AtendAI/1.0' }
        (data['headers'] || {}).each_with_object(base) do |(k, v), h|
          h[interp(k.to_s)] = interp(v.to_s)
        end
      end

      def build_body
        body_template = data['body']
        return nil if body_template.blank?

        if body_template.is_a?(String)
          interp(body_template)
        else
          body_template.deep_transform_values { |v| v.is_a?(String) ? interp(v) : v }.to_json
        end
      end

      def make_request(url, method, headers, body)
        conn = Faraday.new(url: url) do |f|
          f.options.timeout = TIMEOUT
          f.options.open_timeout = 5
          f.adapter Faraday.default_adapter
        end

        case method
        when 'GET'    then conn.get(url, nil, headers)
        when 'POST'   then conn.post(url, body, headers)
        when 'PUT'    then conn.put(url, body, headers)
        when 'PATCH'  then conn.patch(url, body, headers)
        end
      end

      def handle_response(response)
        response_body = begin
          JSON.parse(response.body)
        rescue StandardError
          response.body
        end
        output_var = data['output_variable']
        if output_var.present?
          new_vars = (session.variables || {}).merge(output_var => response_body)
          session.update!(variables: new_vars)
        end
        { next_node_id: data['next'], output: { status: response.status, body: response_body } }
      end
    end
  end
end
