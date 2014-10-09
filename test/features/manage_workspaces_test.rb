require_relative './feature_test_helper'

feature "Manage workspaces" do
  before do
    @user = sign_up_user!
    sign_in_as! @user
    @project = create_project!
    page.click_on "Edit"
    page.click_on "Manage workspaces"
    must_be_on project_workspaces_path(@project)
  end

  scenario "Add workspace to project" do
    click_on "New workspace"
    within("form") do
      fill_in "Title", with: "New workspace"
      fill_in "Description", with: "Testing workspaces feature"
      click_on "Save"
    end
    sleep 1
    must_be_on project_workspace_path(@project, Workspace.last)
    the_flash_notice_must_be "Workspace was successfully created."
    page.must_have_content "New workspace"
  end

  scenario "Edit workspace within project"
  scenario "Remove workspace from project"
  scenario "View workspace"
end