json.array!(@projects) do |project|
  json.extract! project, :id, :name, :type, :value, :owner, :architect, :builder, :description, :starts_at, :ends_at
  json.url project_url(project, format: :json)
end
