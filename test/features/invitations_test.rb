require_relative './feature_test_helper'

feature "Invitations" do
  let(:inviter) { inviter = Fabricate :user }

  scenario "Inviting new co-workers" do
    invited_email = "invitee@#{inviter.company.email_domain}"
    
    sign_in_as! inviter
    click_on "Invite new users"
    fill_in "Email", with: invited_email
    click_on "Send invitation"
    sign_out!
    
    open_email_addressed_to invited_email
    click_email_link_for "Accept invitation"
    must_be_on accept_user_invitation_path
    page.wont_have_content "Company name"
  end

  scenario "Inviting new members at other companies" do
    invited_email = "invitee@other-company.com"
    
    sign_in_as! inviter
    click_on "Invite new users"
    fill_in "Email", with: invited_email
    click_on "Send invitation"
    sign_out!
    
    open_email_addressed_to invited_email
    click_email_link_for "Accept invitation"
    must_be_on accept_user_invitation_path
    page.must_have_content "Company name"
  end
end
