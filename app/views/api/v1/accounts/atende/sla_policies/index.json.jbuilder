json.sla_policies do
  json.array! @policies do |p|
    json.extract! p, :id, :account_id, :name, :description,
                    :first_response_time_threshold, :next_response_time_threshold,
                    :resolution_time_threshold, :is_active, :created_at, :updated_at
  end
end
