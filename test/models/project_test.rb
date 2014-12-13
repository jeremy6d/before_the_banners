require_relative '../test_helper'

describe Project do
  let(:creator) { Fabricate :user, first_name: "Bubba", last_name: "Gump" }
  subject { Fabricate :project, creator: creator }
  before { subject.reload }
  
  it "requires a creator to be set" do
    subject.creator = nil
    subject.wont_be :valid?
  end

  it "rejects time spans that are backwards" do
    subject.starts_at = Time.now - 1.day
    subject.ends_at = Time.now - 1.year
    subject.wont_be :valid?
    subject.errors[:base].must_include "Starting and/or ending dates are invalid"
  end

  it "rejects any project with a time span of zero" do
    subject.starts_at = subject.ends_at = Time.now - 1.day
    subject.wont_be :valid?
  end

  it "adds the creator automatically to the member list" do
    subject.members.must_include subject.creator
  end

  it "sets the creator as the administrator" do
    subject.members.authorized(to: Authorization::ADMINISTER, on: subject).must_include creator
  end

  it "does not grant the creator permission to approve posts" do
    subject.members.authorized(to: Authorization::APPROVE_UPDATES, on: subject).wont_include creator
  end

  it "grants the creator authorization to create updates" do
    subject.members.authorized(to: Authorization::CREATE_UPDATES, on: subject).must_include creator
  end

  it "prevents members with authorization to administer from being removed from membership" do
    assert creator.authorized?(to: Authorization::ADMINISTER, on: subject)
    subject.member_ids.delete(creator.id)
    subject.save
    subject.errors[:base].must_include "Members authorized to administer may not be removed"
  end

  describe "processing an invitation" do
    let(:invited_user) { Fabricate :user }
    before do
      subject.invite! invitee: invited_user, authorizations: [Authorization::ADMINISTER], as: creator
    end

    it "adds the user to the project's members" do
      subject.members.must_include invited_user
    end

    it "adds the proper authorizations to the user" do
      invited_user.reload.authorizations.where(name: Authorization::ADMINISTER, 
                                               project_id: subject.id,
                                               grantor_name: "Bubba Gump").count.must_equal 1
    end
  end
end