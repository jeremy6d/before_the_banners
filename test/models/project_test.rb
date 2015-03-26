require_relative '../test_helper'

# create a company, then have another member join

describe Project do
  let(:creator) do 
    Fabricate :user, first_name: "Bubba", 
                     last_name: "Gump",
                     email: "bgump@niceco.biz",
                     company_attributes: {
                       title: "NiceCo Inc."
                     }
  end

  let(:member) do
    Fabricate :user, first_name: "Jenny",
                     last_name: "Smith",
                     email: "jsmith@bojangles.com",
                     company_attributes: {
                       title: "Bojangles LLC"
                     }
  end

  subject do 
    Fabricate :project, creator: creator,
                        title: "A Great Project",
                        type: "Something wonderful",
                        architect_title: "Nelson Mandela",
                        builder_title: "Cheech Marin",
                        owner_title: "Daddy Warbuck",
                        address: "1 Hacker Way, Richmond, VA 23224"
  end
  
  before do 
    subject.invite! invitee: member, 
                    authorizations: [Authorization::CREATE_UPDATES],
                    as: creator
    subject.reload
  end

  it "indexes search terms" do
    %w(great project something wonderful nelson 
       mandela daddy warbuck cheech marin niceco 
       inc bojangles llc 1 hacker way richmond 
       va 23224).each do |term|
      subject.terms.must_include term
    end 
  end

  it "does not index ubiquitous words" do
    subject.terms.wont_include "a"
  end
  
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
      subject.reload.members.must_include invited_user
    end

    it "adds the proper authorizations to the user" do
      invited_user.reload.authorizations.where(name: Authorization::ADMINISTER, 
                                               project_id: subject.id,
                                               grantor_name: "Bubba Gump").count.must_equal 1
    end
  end
end