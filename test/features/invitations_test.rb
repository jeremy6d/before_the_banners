require_relative './feature_test_helper'

feature "Invitations" do
  before do
    @inviter = sign_up!
    @project = create_project!
    @other_project = create_project!
  end

  scenario "Inviting new co-workers to a project" do
    invited_email = "invitee@#{@inviter.company.email_domain}"

    click_on "Invite new users"
    fill_in "Email", with: invited_email
    check @project.title
    click_on "Send invitation"
    sign_out!

    open_email_addressed_to invited_email
    click_email_link_for "Accept invitation"
    must_be_on accept_user_invitation_path
    page.wont_have_content "Company name"

    fill_in "First name", with: "Invitee"
    fill_in "Last name", with: "Dude"
    fill_in "user[password]", with: PASSWORD
    fill_in "user[password_confirmation]", with: PASSWORD
    click_on "Accept invitation"

    page.must_have_content @project.title
    page.wont_have_content @other_project.title
  end

  scenario "Inviting existing co-workers to a project" do
    @invitee = sign_up!
    sign_out!

    signed_in_as @inviter do
      click_on "Invite new users"
      fill_in "Email", with: @invitee.email
      check @project.title
      click_on "Send invitation"
    end
    
    must_receive_email subject: "[Before the Banners] New notification received",
                       to: @invitee.email
  end

  scenario "Inviting new non-co-workers to your project" do
    invited_email = "invitee@other-company.com"

    click_on "Invite new users"
    fill_in "Email", with: invited_email
    check @project.title
    click_on "Send invitation"
    sign_out!
    
    open_email_addressed_to invited_email
    click_email_link_for "Accept invitation"
    must_be_on accept_user_invitation_path

    fill_in "First name", with: "Invitee"
    fill_in "Last name", with: "Dude"
    fill_in "Company name", with: "TestCo"
    fill_in "user[password]", with: PASSWORD
    fill_in "user[password_confirmation]", with: PASSWORD
    click_on "Accept invitation"

    page.must_have_content @project.title
    page.wont_have_content @other_project.title
  end
end
