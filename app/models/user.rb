class User
  include Mongoid::Document
  include Mongoid::Timestamps

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
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

  ## Lockable
  # field :failed_attempts, type: Integer, default: 0 # Only if lock strategy is :failed_attempts
  # field :unlock_token,    type: String # Only if unlock strategy is :email or :both
  # field :locked_at,       type: Time
  field :first_name,    type: String
  field :last_name,     type: String
  field :company_name,  type: String

  embeds_many :authorizations, inverse_of: :grantee, cascade_callbacks: true
  belongs_to :employer, class_name: "User", inverse_of: :employee
  has_and_belongs_to_many :projects, inverse_of: :member, 
                                     after_remove: :deauthorize_for

  validates_presence_of :first_name, :last_name

  def to_s
    [ first_name, last_name ].join(" ")
  end

  alias_method :full_name, :to_s

  def authorized? to: raise("Must provide name of authorization"), on: raise("Must provide project")
    authorizations.where(name: to, project_id: on.id).exists?
  end

  def authorize! to: raise("Must provide name of authorization"), on: raise("Must provide project"), by: nil
    authorizations.create name: to, project_id: on.id, grantor_name: by.try(:full_name)
    save
  end

  def deauthorize_for project
    authorizations.destroy_all project_id: project.id
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
end