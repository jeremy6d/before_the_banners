require 'test_helper'

describe Company do
  let(:employee) { Fabricate :user, email: "guy@company.com" }
  subject { employee.company }

  it "sets the email domain to the first user's email address on create" do
    subject.email_domain.must_equal "company.com"
  end
end