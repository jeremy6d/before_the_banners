class Company
  include Mongoid::Document
  include Mongoid::Timestamps

  field :title, type: String
  field :email_domain, type: String

  has_many :employees, class_name: "User"

  validates_presence_of   :title, :email_domain
  validates_uniqueness_of :title, :email_domain

  before_validation :set_email_domain, if: Proc.new { |c| c.email_domain.blank? && employees.exists? }

protected
  def set_email_domain
    write_attribute :email_domain, employees.first.email_domain
  end
end