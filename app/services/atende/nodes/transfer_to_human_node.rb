module Atende
  module Nodes
    class TransferToHumanNode < BaseNode
      def execute
        conversation.update!(status: :open)
        session.update!(status: :completed)
        { next_node_id: nil, output: { transferred: true } }
      end
    end
  end
end
