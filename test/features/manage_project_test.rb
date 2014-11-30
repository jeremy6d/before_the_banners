require_relative './feature_test_helper'

feature "Project management" do
  setup do
    sign_up!
    click_on "My projects"
  end

  scenario "Upload photo while creating project" do
    click_on "+ Create New Project"

    attrs = Fabricate.attributes_for :project

    fill_in "Project title", with: attrs[:title]
    fill_in "Project value", with: attrs[:value]
    fill_in "Project type", with: attrs[:type]
    fill_in "Project description", with: attrs[:description]
    fill_in "Owner", with: attrs[:owner_title]
    fill_in "Architect", with: attrs[:architect_title]
    fill_in "Builder", with: attrs[:builder_title]
    pick_date "START DATE", attrs[:starts_at]
    pick_date "END DATE", attrs[:ends_at]
    attach_file "project_logo", File.join(Rails.root, "test", "fixtures", "logo.png")
    click_on "Save"

    the_flash_notice_must_be "Project created."
    page.find(".project-header")[:style].must_match /main_logo\.png/i
  end

  scenario "Upload photo to existing project"
end