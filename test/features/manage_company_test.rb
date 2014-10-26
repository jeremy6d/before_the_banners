require_relative './feature_test_helper'

feature "Manage a company's details" do
  before do
    @mgr = sign_up!
    @co = @mgr.company
  end

  scenario "Editing company as manager" do
    click_on "My company"
    must_be_on edit_company_path
    saop  
  end
end