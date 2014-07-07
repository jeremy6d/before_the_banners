class Update
  include Mongoid::Document
  include Mongoid::Timestamps

  field :title,           type: String
  field :body,            type: String
  field :approval_status, type: String
  field :edits,           type: Hash, default: {}
  field :approved_at,     type: Time

  belongs_to :project
  belongs_to :author,   class_name: "User"
  belongs_to :approver, class_name: "User"

  validates_presence_of :title
end