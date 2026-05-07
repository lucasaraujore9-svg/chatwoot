module Atende
  module Gowa
    class Client
      BASE_URL = ENV.fetch('GOWA_BASE_URL', 'http://gowa:3000').freeze
      TIMEOUT = 10
      MAX_RETRIES = 3

      def initialize(session_id:)
        @session_id = session_id
        @connection = build_connection
      end

      def send_message(phone:, message:)
        post('/api/send/message', {
               sessionId: @session_id,
               phone: phone,
               message: message
             })
      end

      def send_image(phone:, image_url:, caption: nil)
        post('/api/send/image', {
               sessionId: @session_id,
               phone: phone,
               image: image_url,
               caption: caption
             })
      end

      def get_session_status
        get("/api/app/status/#{@session_id}")
      end

      def generate_qr
        get("/api/app/generate-qr/#{@session_id}")
      end

      def logout
        delete("/api/app/logout/#{@session_id}")
      end

      def healthy?
        response = get('/health')
        response[:status] == 'ok'
      rescue StandardError
        false
      end

      private

      def build_connection
        Faraday.new(url: BASE_URL) do |f|
          f.request :json
          f.response :json
          f.request :retry, max: MAX_RETRIES, interval: 0.5, backoff_factor: 2,
                            exceptions: [Faraday::TimeoutError, Faraday::ConnectionFailed]
          f.options.timeout = TIMEOUT
          f.options.open_timeout = 5
        end
      end

      def get(path)
        response = @connection.get(path)
        handle_response(response)
      end

      def post(path, body)
        response = @connection.post(path, body)
        handle_response(response)
      end

      def delete(path)
        response = @connection.delete(path)
        handle_response(response)
      end

      def handle_response(response)
        raise Atende::Gowa::Error, "GOWA API error: #{response.status}" unless response.success?

        response.body
      end
    end

    class Error < StandardError; end
  end
end
