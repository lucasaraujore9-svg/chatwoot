json.extract! @session, :id, :kind, :status, :current_node_id, :variables,
                        :started_at, :last_activity_at, :ended_at, :created_at, :updated_at
json.flow_id @session.flow_id
json.agent_id @session.agent_id
json.conversation_id @session.conversation_id
json.contact_id @session.contact_id
json.node_runs do
  json.array! @session.node_runs.order(:executed_at) do |run|
    json.extract! run, :id, :node_id, :node_type, :status, :output, :error_message, :duration_ms, :executed_at
  end
end
