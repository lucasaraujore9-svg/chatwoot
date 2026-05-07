json.extract! @thread, :id, :account_id, :conversation_id, :created_at, :updated_at
json.messages do
  json.array! @thread.atende_copilot_messages.order(:created_at) do |msg|
    json.extract! msg, :id, :role, :content, :created_at
  end
end
