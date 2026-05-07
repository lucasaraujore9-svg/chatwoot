module Atende
  module AgentTools
    class SalvarVariavel < BaseTool
      def self.schema
        {
          name: 'salvar_variavel',
          description: 'Salva uma variável na sessão atual para uso posterior.',
          parameters: {
            type: 'object',
            properties: {
              chave: { type: 'string', description: 'Nome da variável' },
              valor: { type: 'string', description: 'Valor a salvar' }
            },
            required: %w[chave valor]
          }
        }
      end

      def call(args)
        chave = args['chave'].to_s
        valor = args['valor'].to_s
        new_vars = (session.variables || {}).merge(chave => valor)
        session.update!(variables: new_vars)
        { saved: { chave => valor } }
      end
    end
  end
end
