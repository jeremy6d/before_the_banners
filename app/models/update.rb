class Update
  include Mongoid::Document
  include Mongoid::Timestamps

  field :title,           type: String
  field :body,            type: String
  field :approval_status, type: String
  field :edits,           type: Hash, default: {}
  field :approved_at,     type: Time

  mount_uploader :attachment, MediaUploader

  belongs_to :project
  belongs_to :author,   class_name: "User"
  belongs_to :approver, class_name: "User"
  belongs_to :workspace

  validates_presence_of :title
end