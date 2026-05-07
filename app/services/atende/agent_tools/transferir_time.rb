module Atende
  module AgentTools
    class TransferirTime < BaseTool
      def self.schema
        {
          name: 'transferir_time',
          description: 'Transfere a conversa para um time específico.',
          parameters: {
            type: 'object',
            properties: {
              team_id: { type: 'integer', description: 'ID do time para transferir' }
            },
            required: ['team_id']
          }
        }
      end

      def call(args)
        team = account.teams.find_by(id: args['team_id'])
        return { error: 'Time não encontrado' } unless team

        Conversations::AssignmentService.new(conversation: conversation, team: team).perform
        session.update!(status: :completed)
        { transferred_to_team: team.id }
      end
    end
  end
end
