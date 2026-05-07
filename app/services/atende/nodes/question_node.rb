module Atende
  module Nodes
    # Sends a message and waits for the contact's next reply.
    # The reply is stored in session.variables[data['variable']] by the executor.
    class QuestionNode < BaseNode
      def execute
        content = interp(data['content'].to_s)
        Messages::MessageBuilder.new(nil, conversation, {
                                       content: content,
                                       message_type: :outgoing,
                                       content_type: :text,
                                       private: false
                                     }).perform

        # Signal executor to pause and store reply in given variable
        { next_node_id: nil, wait_for_input: true, variable: data['variable'], output: { sent: content } }
      end
    end
  end
end
