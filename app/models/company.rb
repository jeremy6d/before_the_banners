class Company
  include Mongoid::Document
  include Mongoid::Timestamps

  field :title, type: String

  has_many :employees, class_name: "User"
end