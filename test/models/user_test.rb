require_relative '../test_helper'

describe User do 
  subject { Fabricate :user }
  let(:project) { Fabricate :project }
  let(:other_project) { Fabricate :project }

  describe "with authorization" do
    before do
      subject.projects = [ project, other_project]
      subject.save
    end

    describe "being assigned" do
      before do
        subject.authorize! to: Authorization::APPROVE_POSTS, on: project
        subject.authorize! to: Authorization::ADMINISTER, on: other_project
        subject.save
      end

      it "can retrieve all projects with a specific authorization" do
        subject.reload.projects.authorized_to(Authorization::APPROVE_POSTS).to_a == [project]
      end

      describe "an deauthorized by type and project" do
        before do 
          subject.deauthorize! to: Authorization::APPROVE_POSTS, on: project 
        end

        it "purges the correct authorization" do
          subject.wont_be :authorized?, to: Authorization::APPROVE_POSTS, on: project
        end

        it "does not purge other authorizations" do
          subject.must_be :authorized?, to: Authorization::ADMINISTER, on: other_project
        end
      end
    end

    describe "being removed" do      
      before do
        subject.authorize! to: "approve_posts", on: project
        subject.authorize! to: "approve_posts", on: other_project
        subject.projects.delete(project)
        subject.save
      end

      it "removes authorizations when the user is removed from the project" do
        subject.wont_be :authorized?, to: "approve_posts", on: project
      end

      it "does not remove authorizations from projects the user is still on" do
        subject.must_be :authorized?, to: "approve_posts", on: other_project
      end
    end
  end

  describe "on creation" do
    describe "specifying an existing company email domain" do
      before { Fabricate :company, email_domain: "already.com" }
      
      let(:new_user) do 
        Fabricate :user, email: "user@already.com",
                         company_attributes: { title: "Another title" }
      end

      # before { new_user.valid?; puts Company.first }

      it "prompts user to email the company contact" do
        new_user.errors[:base].must_include "This company already exists; request an invitation from the account manager."
      end
    end
  end
end