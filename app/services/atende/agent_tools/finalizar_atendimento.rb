module Atende
  module AgentTools
    class FinalizarAtendimento < BaseTool
      def self.schema
        {
          name: 'finalizar_atendimento',
          description: 'Resolve a conversa e encerra a sessão do agente.',
          parameters: {
            type: 'object',
            properties: {},
            required: []
          }
        }
      end

      def call(_args)
        conversation.update!(status: :resolved)
        session.update!(status: :completed)
        { resolved: true }
      end
    end
  end
end
