require 'test_helper'

describe User do 
  subject { Fabricate :user }
  let(:project) { Fabricate :project }

  describe "with projects" do
    before do
      subject.projects << project
      subject.save
    end

    describe "being removed" do
      let(:second_project) { Fabricate :project }
      
      before do
        subject.authorize! to: "approve_posts", on: project
        subject.authorize! to: "approve_posts", on: second_project
        subject.projects.delete(project)
        subject.save
      end

      it "removes authorizations when the user is removed from the project" do
        subject.wont_be :authorized?, to: "approve_posts", on: project
      end

      it "does not remove authorizations from projects the user is still on" do
        subject.must_be :authorized?, to: "approve_posts", on: second_project
      end
    end
  end
end