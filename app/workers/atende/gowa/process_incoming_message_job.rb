module Atende
  module Gowa
    class ProcessIncomingMessageJob < ApplicationJob
      queue_as :default

      def perform(channel_id, payload)
        channel = Channel::QrcodeWhatsapp.find_by(id: channel_id)
        return unless channel

        adapted = Atende::Gowa::MessageAdapter.from_webhook(payload)
        return if adapted[:source_id].blank?

        inbox = channel.inbox
        contact_inbox = find_or_create_contact_inbox(inbox, adapted[:sender_phone])
        return unless contact_inbox

        conversation = find_or_create_conversation(contact_inbox, inbox)
        create_message(conversation, adapted)
      end

      private

      def find_or_create_contact_inbox(inbox, phone)
        contact = inbox.account.contacts.find_or_create_by(phone_number: phone) do |c|
          c.name = phone
        end
        ContactInbox.find_or_create_by(contact: contact, inbox: inbox)
      end

      def find_or_create_conversation(contact_inbox, inbox)
        conversation = contact_inbox.conversations.open.last
        conversation ||= ::Conversation.create!(
          account: inbox.account,
          inbox: inbox,
          contact: contact_inbox.contact,
          contact_inbox: contact_inbox
        )
        conversation
      end

      def create_message(conversation, adapted)
        return if conversation.messages.exists?(source_id: adapted[:source_id])

        conversation.messages.create!(
          content: adapted[:content],
          message_type: :incoming,
          content_type: adapted[:content_type],
          source_id: adapted[:source_id],
          account: conversation.account,
          inbox: conversation.inbox,
          sender: conversation.contact
        )
      end
    end
  end
end
