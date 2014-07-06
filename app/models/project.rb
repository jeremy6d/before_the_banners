class Project
  include Mongoid::Document
  field :name, type: String
  field :type, type: String
  field :value, type: String
  field :owner, type: String
  field :architect, type: String
  field :builder, type: String
  field :description, type: String
  field :starts_at, type: Time
  field :ends_at, type: Time
end
