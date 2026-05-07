module Atende
  module Nodes
    class EndNode < BaseNode
      def execute
        session.update!(status: :completed)
        { next_node_id: nil, output: { completed: true } }
      end
    end
  end
end
