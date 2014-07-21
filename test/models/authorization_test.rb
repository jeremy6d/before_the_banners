require 'test_helper'

describe Authorization do
  let(:member)  { Fabricate :user }
  let(:project) { Fabricate.build :project }

  it "cannot be granted for a project the user is not a member of" do
    admin_auth = member.authorizations.build name: Authorization::ADMINISTER, 
                                             project: project
    admin_auth.wont_be :valid?
    admin_auth.errors[:base].must_include "Cannot authorize non-member"
  end
end