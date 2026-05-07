json.policies do
  json.array! @policies do |p|
    json.extract! p, :id, :account_id, :agent_id, :max_conversations, :is_active, :created_at, :updated_at
  end
end
