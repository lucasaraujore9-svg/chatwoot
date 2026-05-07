module Atende
  module Gowa
    class MessageAdapter
      # Converts GOWA webhook payload → Chatwoot message format
      def self.from_webhook(payload)
        {
          source_id: payload.dig('message', 'id'),
          sender_phone: payload.dig('sender', 'id')&.split('@')&.first,
          content: extract_content(payload),
          message_type: :incoming,
          content_type: detect_content_type(payload),
          attachments: extract_attachments(payload)
        }
      end

      # Converts Chatwoot message → GOWA send format
      def self.to_gowa(message, session_id)
        {
          sessionId: session_id,
          phone: message.conversation.meta[:sender][:phone_number],
          message: message.content
        }
      end

      private_class_method def self.extract_content(payload)
        payload.dig('message', 'conversation') ||
        payload.dig('message', 'extendedTextMessage', 'text') ||
        payload.dig('message', 'imageMessage', 'caption') ||
        ''
      end

      private_class_method def self.detect_content_type(payload)
        msg = payload['message'] || {}
        return :image if msg['imageMessage']
        return :audio if msg['audioMessage']
        return :video if msg['videoMessage']
        return :file if msg['documentMessage']

        :text
      end

      private_class_method def self.extract_attachments(payload)
        msg = payload['message'] || {}
        media_message = msg['imageMessage'] || msg['audioMessage'] ||
                        msg['videoMessage'] || msg['documentMessage']
        return [] unless media_message

        [{ url: media_message['url'], mime_type: media_message['mimetype'] }]
      end
    end
  end
end
