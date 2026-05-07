module Atende
  module AgentTools
    class AdicionarLabel < BaseTool
      def self.schema
        {
          name: 'adicionar_label',
          description: 'Adiciona uma label/etiqueta à conversa atual.',
          parameters: {
            type: 'object',
            properties: {
              label: { type: 'string', description: 'Nome da label a adicionar' }
            },
            required: ['label']
          }
        }
      end

      def call(args)
        label = args['label'].to_s.downcase.strip
        Labels::UpdateService.new(conversation, [label] | conversation.label_list).perform
        { label_added: label }
      end
    end
  end
end
