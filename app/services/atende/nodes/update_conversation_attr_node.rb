module Atende
  module Nodes
    class UpdateConversationAttrNode < BaseNode
      ALLOWED_FIELDS = %w[priority status additional_attributes].freeze

      def execute
        field = data['field'].to_s
        value = interp(data['value'].to_s)

        if ALLOWED_FIELDS.include?(field)
          if field == 'additional_attributes'
            key = data['attr_key'].to_s
            attrs = conversation.additional_attributes.merge(key => value)
            conversation.update!(additional_attributes: attrs)
          else
            conversation.update!(field => value)
          end
        end

        { next_node_id: data['next'], output: { field: field, value: value } }
      end
    end
  end
end
