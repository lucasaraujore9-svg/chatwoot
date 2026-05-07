json.audit_logs do
  json.array! @logs do |log|
    json.extract! log, :id, :auditable_type, :auditable_id, :action, :audited_changes, :version, :created_at
    json.user_id log.user_id
  end
end
json.meta do
  json.count @logs.total_count
  json.current_page @logs.current_page
end
