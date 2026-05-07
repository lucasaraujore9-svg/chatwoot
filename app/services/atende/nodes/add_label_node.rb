module Atende
  module Nodes
    class AddLabelNode < BaseNode
      def execute
        label = interp(data['label'].to_s).downcase
        Labels::UpdateService.new(conversation, [label] | conversation.label_list).perform
        { next_node_id: data['next'], output: { label: label } }
      end
    end
  end
end
