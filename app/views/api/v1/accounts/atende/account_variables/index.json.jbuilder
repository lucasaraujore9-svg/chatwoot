json.variables do
  json.array! @variables do |var|
    json.extract! var, :id, :key, :var_type, :is_secret, :created_at, :updated_at
    json.value var.is_secret ? nil : var.value_encrypted
  end
end
