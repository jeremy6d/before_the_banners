class Project
  include Mongoid::Document
  include Mongoid::Timestamps

  field :title,           type: String
  field :type,            type: String
  field :value,           type: String
  field :owner_name,      type: String
  field :architect_name,  type: String
  field :builder_name,    type: String
  field :description,     type: String
  field :starts_at,       type: Date
  field :ends_at,         type: Date

  has_many :updates

  validates_presence_of :title,
                        :starts_at,
                        :ends_at
  validate :date_range_valid?

protected
  def date_range_valid?
    starts_at < ends_at
  end
end
