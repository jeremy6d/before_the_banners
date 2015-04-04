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
focus
  scenario "Password reset" do
    @user = sign_up!
    sign_out!

    visit("/")
    click_on "Sign in"

    click_on "Forgot your password?"

    fill_in "Email", with: @user.email
    click_on "Send me reset password instructions"

    open_email_addressed_to @user.email
    click_email_link_for "Change my password"

    fill_in "New password", with: "newpassword"
    fill_in "Confirm your new password", with: "newpassword"
    click_on "Change my password"

    the_flash_notice_must_be "Your password was changed successfully. You are now signed in."

    must_be_on projects_path
    sign_out!

    visit("/")
    click_on "Sign in"
    fill_in "Email", with: @user.email
    fill_in "Password", with: "newpassword"
    click_on "Sign in"
saop
    the_flash_notice_must_be "Signed in successfully."
    must_be_signed_in
  end
end