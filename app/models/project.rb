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

  mount_uploader :logo, LogoUploader

  has_many   :updates
  belongs_to :creator, class_name: "User"
  has_and_belongs_to_many :members, class_name: "User"

  validates_presence_of :title,
                        :starts_at,
                        :ends_at,
                        :creator_id
  validate :date_range_valid
  validate :admins_are_members, on: :update

  before_create :add_creator_as_member
  after_create  :authorize_creator_to_administer

protected
  def date_range_valid
    errors[:base] << "Starting and/or ending dates are invalid" unless (starts_at < ends_at)
  end

  def admins_are_members
    admin_ids = User.authorized(to: Authorization::ADMINISTER, on: self).pluck(:_id)

    unless (member_ids & admin_ids) == admin_ids
      errors[:base] << "Members authorized to administer may not be removed"
    end
  end

  def add_creator_as_member
    member_ids << creator.id
  end

  def authorize_creator_to_administer
    creator.authorize! to: Authorization::ADMINISTER, on: self
  end
end