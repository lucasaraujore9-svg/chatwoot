module Atende
  module AgentTools
    class EncaminharAtendimento < BaseTool
      def self.schema
        {
          name: 'encaminhar_atendimento',
          description: 'Transfere a conversa para um atendente humano e encerra a sessão do agente.',
          parameters: {
            type: 'object',
            properties: {
              mensagem: { type: 'string', description: 'Mensagem para o atendente' }
            },
            required: []
          }
        }
      end

      def call(args)
        mensagem = args['mensagem'].presence
        if mensagem
          Messages::MessageBuilder.new(nil, conversation, {
                                         content: mensagem, message_type: :outgoing, content_type: :text, private: true
                                       }).perform
        end
        conversation.update!(status: :open)
        session.update!(status: :completed)
        { transferred: true }
      end
    end
  end
end
