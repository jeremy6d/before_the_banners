class Notification
  include Mongoid::Document
  include Mongoid::Timestamps::Created

  field :text,      type: String
  field :viewed,    type: Boolean, default: false
  field :dismissed, type: Boolean, default: false

  belongs_to :recipient, class_name: 'User', inverse_of: :notifications
end