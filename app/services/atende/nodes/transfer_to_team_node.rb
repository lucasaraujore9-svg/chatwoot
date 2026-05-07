module Atende
  module Nodes
    class TransferToTeamNode < BaseNode
      def execute
        team_id = data['team_id']
        team = account.teams.find_by(id: team_id)
        if team
          Conversations::AssignmentService.new(
            conversation: conversation,
            team: team
          ).perform
        end
        session.update!(status: :completed)
        { next_node_id: nil, output: { team_id: team_id } }
      end
    end
  end
end
