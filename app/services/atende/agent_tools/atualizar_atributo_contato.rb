module Atende
  module AgentTools
    class AtualizarAtributoContato < BaseTool
      ALLOWED = %w[name email phone_number].freeze

      def self.schema
        {
          name: 'atualizar_atributo_contato',
          description: 'Atualiza um atributo do contato (name, email, phone_number ou atributo customizado via additional_attributes).',
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
          contact.update!(campo => valor)
        else
          attrs = contact.additional_attributes.merge(campo => valor)
          contact.update!(additional_attributes: attrs)
        end
        { updated_contact_attr: { campo => valor } }
      end
    end
  end
end
