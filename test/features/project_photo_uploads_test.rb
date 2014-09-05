require_relative './feature_test_helper'

feature "Project photo uploads" do
focus
  scenario "Upload photo while creating project" do
    user = sign_up_user!
    click_on "My projects"
    click_on "Create new project"

    attrs = Fabricate.attributes_for :project

    fill_in "Project title", with: attrs[:title]
    fill_in "Project value", with: attrs[:value]
    fill_in "Project type", with: attrs[:type]
    fill_in "Project description", with: attrs[:description]
    pick_date "Start date", attrs[:starts_at]
    pick_date "End date", attrs[:ends_at]
screenshot!
    attach_file "Project logo", File.join(Rails.root, "test", "fixtures", "logo.png")

  end

  scenario "Upload photo to existing project"
end