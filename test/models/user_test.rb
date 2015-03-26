require_relative '../test_helper'

describe User do 
  subject { Fabricate :user }

  describe "with authorization" do
    before do
      @project = Fabricate :project, creator: subject
      @other_project = Fabricate :project, creator: subject
    end

    it "should grant administer authorization on all created projects" do
      subject.authorizations.map(&:project).must_include @project, @other_project
    end

    describe "explicitly granted" do
      before do
        subject.authorize! to: Authorization::APPROVE_UPDATES, on: @project
      end

      describe "being assigned" do
        it "can retrieve all projects with a specific authorization" do
          subject.reload.projects.authorized_to(Authorization::APPROVE_UPDATES).to_a == [@project]
        end

        it "writes the BSON id, not the slug, to the foreign key" do
          assert subject.reload.project_ids.all? { |id| id.is_a?(BSON::ObjectId) }
        end

        describe "an deauthorized by type and project" do
          before do
            subject.deauthorize! to: Authorization::APPROVE_UPDATES, on: @project 
            subject.reload
          end

          it "purges the correct authorization" do
            subject.wont_be :authorized?, to: Authorization::APPROVE_UPDATES, on: @project
          end

          it "does not purge other authorizations" do
            subject.must_be :authorized?, to: Authorization::ADMINISTER, on: @other_project
          end

          it "does not remove from project" do
            subject.projects.must_include @project
          end
        end
      end
    end

    describe "being removed" do      
      before do
        subject.authorize! to: Authorization::APPROVE_UPDATES, on: @other_project
        subject.projects.delete(@project)
        subject.reload
      end

      it "removes authorizations when the user is removed from the project" do
        subject.wont_be :authorized?, to: Authorization::APPROVE_UPDATES, on: @project
      end

      it "does not remove authorizations from projects the user is still on" do
        subject.must_be :authorized?, to: Authorization::APPROVE_UPDATES, on: @other_project
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

  describe "on invitation" do
    let(:project) { Fabricate :project }
    let(:owner) { project.creator }
    let(:new_auth) do
      Authorization.new name: Authorization::CREATE_UPDATES,
                        project_id: project.id,
                        grantor_name: owner
    end
    let(:attrs) do
      { email: "new-user@company.com", 
        projects: [ project ],
        company: nil, #simulate new company
        authorizations: [ new_auth ] }
    end

    let(:invitee) { User.invite! attrs, owner }

    it "sets the project to be accessible to the invitee" do
      invitee.projects.must_include project
    end
  end
end