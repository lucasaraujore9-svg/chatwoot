json.roles do
  json.array! @roles do |r|
    json.extract! r, :id, :account_id, :name, :description, :permissions, :created_at, :updated_at
  end
end
