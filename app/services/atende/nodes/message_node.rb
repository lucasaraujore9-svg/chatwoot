module Atende
  module Nodes
    class MessageNode < BaseNode
      def execute
        content = interp(data['content'].to_s)
        Messages::MessageBuilder.new(nil, conversation, {
                                       content: content,
                                       message_type: :outgoing,
                                       content_type: :text,
                                       private: false
                                     }).perform
        { next_node_id: data['next'], output: { sent: content } }
      end
    end
  end
end
