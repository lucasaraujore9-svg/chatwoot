module Atende
  module Nodes
    # Sends a numbered menu and waits for user's numeric choice.
    # Options: [{ label: 'Option A', next: 'node_id' }, ...]
    class MenuNode < BaseNode
      def execute
        options = data['options'] || []
        lines = [interp(data['content'].to_s)]
        options.each.with_index(1) do |opt, idx|
          lines << "#{idx}. #{interp(opt['label'].to_s)}"
        end
        content = lines.join("\n")
        Messages::MessageBuilder.new(nil, conversation, {
                                       content: content,
                                       message_type: :outgoing,
                                       content_type: :text,
                                       private: false
                                     }).perform

        { next_node_id: nil, wait_for_input: true, variable: '_menu_choice', menu_options: options, output: { sent: content } }
      end
    end
  end
end
