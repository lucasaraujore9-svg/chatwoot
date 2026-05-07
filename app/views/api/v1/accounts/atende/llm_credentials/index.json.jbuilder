json.credentials do
  json.array! @credentials do |c|
    json.partial! 'llm_credential', llm_credential: c
  end
end
