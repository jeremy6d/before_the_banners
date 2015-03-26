require_relative './feature_test_helper'

WORKSPACES = %w(plumbing foundation interior electrical)

feature "Manage updates and approvals" do 
  before do
    @approver = sign_up!(email: "approver@company.com") do |approver|
      @project = create_project!
      add_workspaces! *WORKSPACES
      invite_to! @project, "updater@company.com", "Create updates"
    end

    @invitee = accept_invite_for! "updater@company.com"
  end

  scenario "view updates by workspace" do
    add_update_to! @project, body: "Testing 123", workspace: "plumbing"
    add_update_to! @project, body: "trying 456", workspace: "interior"
    add_update_to! @project, body: "attempt 789", workspace: "foundation"

    click_on "My projects"
    click_on @project.title

    [ "Testing 123",
      "trying 456",
      "attempt 789" ].each do |body| 
        page.must_have_content body 
    end

    filter_on! "plumbing"
    
    page.must_have_content "Testing 123"
    page.wont_have_content "trying 456"
    page.wont_have_content "attempt 789"

    filter_on! "interior"

    page.must_have_content "trying 456"
    page.wont_have_content "Testing 123"
    page.wont_have_content "attempt 789"

    filter_on!  "electrical"

    page.wont_have_content  "Testing 123"
    page.wont_have_content  "trying 456" 
    page.wont_have_content "attempt 789"

    remove_filter!

    [ "Testing 123",
      "trying 456",
      "attempt 789" ].each do |body| 
        page.must_have_content body 
    end
  end

  scenario "add update to project and approve" do
    skip "approval workflow is deferred"  

    # click_on "My projects"
    # click_on @project.title
    # click_on "Add update"
    # must_be_on new_project_update_path(@project)
    # select "foundation", from: "Workspace"
    # within('form') do
    #   fill_in "Body", with: (@text = Faker::Lorem.paragraph)
    #   attach_file "update_attachment", File.join(Rails.root, "test", "fixtures", "planning.jpg")
    #   click_on "Submit update"
    # end

    # must_be_on project_path(@project)
    # the_flash_notice_must_be "Update submitted."
    # page.wont_have_content @text
    # page.must_contain_image_for "thumb_planning.jpg"
  end

  # scenario "edit update within project"
  # scenario "delete update from project"
end