json.agents do
  json.array! @agents do |agent|
    json.partial! 'agent', agent: agent
  end
end
