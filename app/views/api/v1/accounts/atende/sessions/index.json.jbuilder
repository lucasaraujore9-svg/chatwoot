json.sessions do
  json.array! @sessions do |session|
    json.extract! session, :id, :kind, :status, :current_node_id, :variables,
                           :started_at, :last_activity_at, :ended_at, :created_at
    json.flow_id session.flow_id
    json.agent_id session.agent_id
    json.conversation_id session.conversation_id
  end
end
json.meta do
  json.count @sessions.total_count
  json.current_page @sessions.current_page
end
