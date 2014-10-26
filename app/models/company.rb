class Company
  include Mongoid::Document
  include Mongoid::Timestamps

  field :title, type: String
  field :email_domain, type: String
  field :description, type: String

  mount_uploader :logo, LogoUploader

  has_many    :employees, class_name: "User"
  belongs_to  :manager,   class_name: "User", 
                          inverse_of: nil

  validates_presence_of   :title, :email_domain
  validates_uniqueness_of :title, :email_domain

  before_validation :set_email_domain, if: Proc.new { |c| c.email_domain.blank? && employees.exists? }
  before_create     :make_creator_manager!

protected
  def set_email_domain
    write_attribute :email_domain, employees.first.email_domain
  end

  def make_creator_manager!
    self.manager = employees.first
  end
end