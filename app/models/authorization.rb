class Authorization
  include Mongoid::Document
  include Mongoid::Timestamps::Created

  def self.types
    %w(administer approve_updates create_updates)
  end

  types.each do |name|
    const_set name.upcase, name
  end

  field :name, type: String
  field :grantor_name, type: String
  # field :project_id,  type: BSON::ObjectId

  embedded_in :grantee, class_name: "User"

  belongs_to :project # do I need to maintain this manually?

  validates_presence_of :name,
                        :project_id
  validates_uniqueness_of :name, scope: :project_id
  validate :member_of_project?

protected
  def member_of_project?
    errors[:base] << "Cannot authorize non-member" unless grantee.project_ids.include?(project_id)
  end
end