module Atende
  module Nodes
    class UpdateContactAttrNode < BaseNode
      ALLOWED_FIELDS = %w[name email phone_number additional_attributes].freeze

      def execute
        field = data['field'].to_s
        value = interp(data['value'].to_s)

        if ALLOWED_FIELDS.include?(field)
          if field == 'additional_attributes'
            key = data['attr_key'].to_s
            attrs = contact.additional_attributes.merge(key => value)
            contact.update!(additional_attributes: attrs)
          else
            contact.update!(field => value)
          end
        end

        { next_node_id: data['next'], output: { field: field, value: value } }
      end
    end
  end
end
