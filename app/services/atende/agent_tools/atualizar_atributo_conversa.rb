module Atende
  module AgentTools
    class AtualizarAtributoConversa < BaseTool
      ALLOWED = %w[priority status].freeze

      def self.schema
        {
          name: 'atualizar_atributo_conversa',
          description: 'Atualiza um atributo da conversa (priority, status ou atributo customizado).',
          parameters: {
            type: 'object',
            properties: {
              campo: { type: 'string', description: 'Nome do campo' },
              valor: { type: 'string', description: 'Novo valor' }
            },
            required: %w[campo valor]
          }
        }
      end

      def call(args)
        campo = args['campo'].to_s
        valor = args['valor'].to_s
        if ALLOWED.include?(campo)
          conversation.update!(campo => valor)
        else
          attrs = conversation.additional_attributes.merge(campo => valor)
          conversation.update!(additional_attributes: attrs)
        end
        { updated_conversation_attr: { campo => valor } }
      end
    end
  end
end
