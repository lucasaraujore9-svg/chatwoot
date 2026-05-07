json.flows do
  json.array! @flows do |flow|
    json.partial! 'api/v1/accounts/atende/flows/flow', flow: flow
  end
end
json.meta do
  json.count @flows.total_count
  json.current_page @flows.current_page
end
