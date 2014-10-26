require_relative './feature_test_helper'

feature "Manage updates and approvals" do 
  before do
    @approver = sign_up!(email: "approver@company.com") do |approver|
      @project = create_project!
      add_workspaces! "plumbing", "foundation", "interior"
      invite_to! @project, "updater@company.com", "Create updates"
    end

    @invitee = accept_invite_for! "updater@company.com"
  end

  scenario "add update to project and approve" do
    skip("deferred")
    click_on "My projects"
    click_on @project.title
    click_on "Add update"
    must_be_on new_project_update_path(@project)
    select "foundation", from: "Workspace"
    within('form') do
      fill_in "Body", with: (@text = Faker::Lorem.paragraph)
      attach_file "update_attachment", File.join(Rails.root, "test", "fixtures", "planning.jpg")
      click_on "Submit update"
    end

    must_be_on project_path(@project)
    the_flash_notice_must_be "Update submitted."
    page.wont_have_content @text
  end

  # scenario "edit update within project"
  # scenario "delete update from project"
end