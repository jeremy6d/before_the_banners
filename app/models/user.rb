class User
  include Mongoid::Document
  include Mongoid::Timestamps

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, 
         :validatable #,:confirmable

  ## Database authenticatable
  field :email,              type: String, default: ""
  field :encrypted_password, type: String, default: ""

  ## Recoverable
  field :reset_password_token,   type: String
  field :reset_password_sent_at, type: Time

  ## Rememberable
  field :remember_created_at, type: Time

  ## Trackable
  field :sign_in_count,      type: Integer, default: 0
  field :current_sign_in_at, type: Time
  field :last_sign_in_at,    type: Time
  field :current_sign_in_ip, type: String
  field :last_sign_in_ip,    type: String

  ## Confirmable
  field :confirmation_token,   type: String
  field :confirmed_at,         type: Time
  field :confirmation_sent_at, type: Time
  # field :unconfirmed_email,    type: String # Only if using reconfirmable

  ## Invitable
  field :invitation_token, type: String
  field :invitation_created_at, type: Time
  field :invitation_sent_at, type: Time
  field :invitation_accepted_at, type: Time
  field :invitation_limit, type: Integer

  field :first_name,    type: String
  field :last_name,     type: String

  mount_uploader :avatar, AvatarUploader
  
  embeds_many :authorizations, inverse_of: :grantee, cascade_callbacks: true
  has_many :notifications, inverse_of: :recipient do
    def current
      where(dismissed: false).tap do |scope|
        scope.set(viewed: true)
      end
    end
  end
  belongs_to :company
  accepts_nested_attributes_for :company
  has_and_belongs_to_many :projects, inverse_of: :members, 
                                     after_remove: :deauthorize_for do
    def authorized_to(auth_name)
      project_ids = base.authorizations.where(name: auth_name).pluck(:project_id)
      where(:_id.in => project_ids)
    end
  end

  # has_many :created_projects, inverse_of: :creator, class_name: "Project"

  validates_presence_of :first_name, :last_name, :company
  validate :no_duplicate_company, if: Proc.new { |u| u.company.try :new_record? }

  index( { invitation_token: 1 },           { background: true} )
  index( { invitation_by_id: 1 },           { background: true} )
  index( { "authorizations.project" => 1 })
  index( { "authorizations.name"    => 1 })
  index( { "authorizations.project" => 1, 
           "authorizations.name" => 1 },    { unique: true })

  def to_s
    [ first_name, last_name ].join(" ")
  end

  alias_method :full_name, :to_s

  def email_domain
    read_attribute(:email).split("@").last
  end

  def authorized? to: raise("Must provide name of authorization"), on: raise("Must provide project")
    authorizations.where(name: to, project_id: on.id).exists?
  end

  def authorize! to: raise("Must provide name of authorization"), on: raise("Must provide project"), by: nil
    authorizations.create name: to, project_id: on.id, grantor_name: by.try(:full_name)
    save
  end

  def deauthorize! to: nil, on: nil
    query = {}.tap do |q|
      q[:name] = to if to
      q[:project_id] = on.id if on
    end

    authorizations.delete_all query

    save
  end

  def deauthorize_for project
    authorizations.delete_all project: project
  end

  scope :authorized, ->(to: nil, on: nil) {
    query = {}
    query[:name] = to if to
    query[:project_id] = case on.class.to_s
    when "BSON::ObjectId"
      on
    when "Project"
      on.id
    else
      raise "Unrecognized authorization object"
    end if on

    elem_match authorizations: query
  }

  def notify! text
    notifications.create(text: text).tap do |n|
      NotificationMailer.email(n).deliver
    end
  end

protected
  def no_duplicate_company
    if Company.where(email_domain: company.email_domain).exists?
      errors[:base] << "This company already exists; request an invitation from the account manager."
    end
  end
end