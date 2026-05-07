json.companies do
  json.array! @companies do |c|
    json.extract! c, :id, :account_id, :name, :website, :industry, :description, :additional_attributes, :created_at, :updated_at
  end
end
json.meta do
  json.count @companies.total_count
  json.current_page @companies.current_page
end
