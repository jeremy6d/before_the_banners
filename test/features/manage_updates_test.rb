require_relative './feature_test_helper'

feature "Manage updates" do 
  before do
    # user with project exists
    @user = sign_up!
    @project = create_project!
    add_workspaces! "plumbing", "foundation", "interior"
    click_on "Back to"
  end

  scenario "add update to project" do
    click_on "Add update"
    skip("not ready yet")
  end

  scenario "edit update within project"
  scenario "delete update from project"
end