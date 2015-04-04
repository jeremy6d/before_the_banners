require_relative './feature_test_helper'

feature "Basic account activity" do
  # scenario "Sign up for an account" do
  #   @user = sign_up!
  #   # an_email_was_sent_with to: @user.email
  #   User.count.must_equal 1
  #   # open_email_addresed_to @user.email
  #   # click_email_link_for "Confirm"
  #   # the_flash_notice_must_be "you confirmed"
  # end

  scenario "Password reset" do
    @user = sign_up!
    sign_out!

    visit("/")
    find("a.sign-in", visible: false).click
saop
screenshot!
    click_on "Forgot password"

    fill_in "Email", with: @user.email
    fill_in "Email Confirmation", with: @user.email
    click_on "Submit"

    open_email_addresed_to @user.email
    click_email_link_for "reset password"

    fill_in "Password", with: "newpassword"
    fill_in "Password confirmation", with: "newpassword"
    click_on "Submit"

    the_flash_notice_must_be "Password successfully reset"
    must_be_on root_path
    sign_out!

    visit("/")
    click_on "Sign In"
    fill_in "Email", with: user_email
    fill_in "Password", with: "newpassword"

    must_be_on dashboard_path
    the_flash_notice_must_be "Signed in successfully."
  end
end