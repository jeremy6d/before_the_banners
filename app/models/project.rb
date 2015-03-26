class Project
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Slug

  DEFAULT_AUTHORIZATIONS = [
    Authorization::ADMINISTER,
    Authorization::CREATE_UPDATES
  ]

  field :title,             type: String
  field :type,              type: String
  field :value,             type: Integer
  field :owner_title,       type: String
  field :architect_title,   type: String
  field :builder_title,     type: String
  field :description,       type: String
  field :starts_at,         type: Date
  field :ends_at,           type: Date
  field :address,           type: String
  field :terms,             type: Array, default: []

  mount_uploader :logo, LogoUploader

  has_many   :updates
  has_many   :workspaces
  belongs_to :creator, class_name: "User", inverse_of: nil
  # belongs_to :owner, class_name: "Company"
  # belongs_to :architect, class_name: "Company"
  # belongs_to :builder, class_name: "Company"
  has_and_belongs_to_many :members, class_name: "User"

  validates_presence_of :title,
                        :creator_id
  validates_numericality_of :value
  validate :date_range_valid
  validate :admins_are_members, on: :update

  before_save do
    add_creator_as_member if new_record?
    index_search_terms
  end

  after_create  :grant_default_authorizations!

  slug :title, history: true

  def companies
    Company.find members.only(:company_id).map(&:company_id)
  end

  def invite! invitee: nil, authorizations: [], as: nil
    raise "No user specified" if invitee.nil?

    invitee.projects << self
    
    authorizations.each do |auth_name|
      invitee.authorizations.build name: auth_name,
                                   project_id: id,
                                   grantor_name: as.try(:full_name)
    end

    invitee.save
  end

  def self.condition_terms term_list
    term_list.split(" ").
              map { |t| 
                t.strip.downcase.gsub(/[^\w]+/, "") 
              }.reject { |t| 
                t.blank? || %w(a an the or and).include?(t) 
              }.uniq
  end

protected
  def date_range_valid
    case 
    when starts_at.blank?
      errors[:starts_at] << "must be specified."
    when ends_at.blank?
      errors[:ends_at] << "must be specified."
    when (starts_at >= ends_at)
      errors[:base] << "Starting and/or ending dates are invalid"
    end 
  end

  def admins_are_members
    admin_ids = User.authorized(to: Authorization::ADMINISTER, on: self).pluck(:_id)

    unless (member_ids & admin_ids) == admin_ids
      errors[:base] << "Members authorized to administer may not be removed"
    end
  end

  def add_creator_as_member
# binding.pry
    # write_attribute :member_ids, [creator.id]
    self.members.push creator
  end

  def grant_default_authorizations!
    DEFAULT_AUTHORIZATIONS.each do |auth|
      creator.authorize! to: auth, on: self
    end
  end

  def cache_titles!
    write_attribute(:owner_title, title_for(owner)) if owner
    write_attribute(:architect_title, title_for(architect)) if architect
    write_attribute(:builder_title, title_for(builder)) if builder
  end

  def title_for user
    "#{user.full_name}, #{user.company.title}"
  end

  def index_search_terms
    write_attribute :terms, search_terms
  end

private
  def search_terms
    Project.condition_terms [ title,
                      type,
                      owner_title,
                      architect_title,
                      builder_title,
                      companies.map(&:title),
                      address.try(:split, ",") ].
                    flatten.
                    join(" ")
  end
end