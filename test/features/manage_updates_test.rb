require_relative './feature_test_helper'

WORKSPACES = %w(plumbing foundation interior)

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

    click_on "My projects"
    click_on @project.title

    [ "Testing 123",
      "trying 456" ].each do |body| 
        page.must_have_content body 
    end

    select "plumbing", from: "Workspace"
    click_on "Filter"

    page.must_have_content "Testing 123"
    page.wont_have_content "trying 456"

    select "interior", from: "Workspace"
    click_on "Filter"

    page.must_have_content "trying 456"
    page.wont_have_content "Testing 123"

    select "foundation", from: "Workspace"
    click_on "Filter"

    page.wont_have_content  "Testing 123"
    page.wont_have_content  "trying 456" 

    select "", from: "Workspace"
    click_on "Filter"

    page.must_have_content  "Testing 123"
    page.must_have_content  "trying 456"  
    
  end

  scenario "add update to project and approve" do
    skip("approval workflow is deferred")
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