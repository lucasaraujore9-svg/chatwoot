class AddAgentFkToAtendeSessions < ActiveRecord::Migration[7.0]
  def change
    add_foreign_key :atende_sessions, :atende_agents, column: :agent_id, on_delete: :nullify
  end
end
