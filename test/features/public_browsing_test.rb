require_relative './feature_test_helper'

feature "Public browsing" do
  before do
    sign_up! do 
      @project = create_project! title: "Spatula Warehouse",
                                 architect_title: "Bubba's Architcture"
      add_workspaces! "one", "two", "three"
      @updates = 5.times.map do
        add_update_to! @project
      end
    end

    # ensure not signed in
    sign_out!
  end

  scenario "An unauthenticated visitor views the project page from a direct link" do
    # visitor directly accesses the URL of project page
    visit project_path(@project)

    # visitor sees project information
    page.must_have_content @project.title.titleize

    @updates.map(&:body).each do |body|
      page.must_have_content body.slice(0,50)
    end

    # visitor does not see admin functions
    page.wont_have_css("ul.operations.off--page")
    page.wont_have_content "Add update"
    page.wont_have_content "Edit"
  end

  scenario "An unauthenticated visitor searches for a project page" do
    # visitor navigates to landing page and searches
    visit root_path
    fill_in "Search projects", with: "bubba\n"    

    # visitor should see search results
    page.must_have_content "Spatula Warehouse"
    click_on "Spatula Warehouse"
    must_be_on project_path(@project)
  end
end