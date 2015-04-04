module FeatureHelpers
  module AccountHelpers
    def sign_out!
      visit dashboard_path

      if page.has_content?(/Sign out/i)
        page.all("a", text: /Sign out/i).first.click
        sleep 0.1 # argh
        must_be_on root_path
      end

      must_be_signed_out
    end

    # pass signed up user into the block
    # return false in the block to skip sign out
    def sign_up! attrs = {}, &block
      sign_out!
      user_attrs = Fabricate.attributes_for(:user).merge attrs
  
      within("form#new_user") do
        fill_in "Company email address", with: user_attrs[:email]
        fill_in "First name", with: user_attrs[:first_name]
        fill_in "Last name", with: user_attrs[:last_name]
        fill_in "user_password", with: PASSWORD
        fill_in "user_password_confirmation", with: PASSWORD
        fill_in "Company name", with: user_attrs[:company_attributes][:title]

        click_on "Sign up"
      end

      the_flash_notice_must_be "Get started by setting up your first project!"
      must_be_on new_project_path

      User.last.tap do |u|
        (yield(u) and sign_out!) if block_given?
      end
    end

    # return false in the block to skip sign out
    def sign_in_as! input, &block
      sign_out!
      visit new_user_session_path

      user_email = case input.class.to_s
        when "String"
          input
        when "User"
          input.email
        else
          raise ArgumentError.new
        end

      within("form#new_user") do
        fill_in "Email", with: user_email
        fill_in "Password", with: PASSWORD
        click_on "Sign in"
      end

      the_flash_notice_must_be "Signed in successfully."
      must_be_signed_in

      (yield and sign_out!) if block_given?
    end

    alias_method :signed_in_as, :sign_in_as!

    def accept_invite_for! invited_email, in_attrs = {}
      user_attrs = Fabricate.attributes_for(:user, in_attrs)

      open_email_addressed_to invited_email
      click_email_link_for "Accept invitation"

      must_be_on accept_user_invitation_path
      page.wont_have_content "Company name"

      fill_in "First name", with: user_attrs[:first_name]
      fill_in "Last name", with: user_attrs[:last_name]
      fill_in "user[password]", with: PASSWORD
      fill_in "user[password_confirmation]", with: PASSWORD
      click_on "Accept invitation"

      User.last.tap do |u|
        (yield(u) and sign_out!) if block_given?
      end
    end

    def must_be_signed_out
      assert !page.has_content?(/Sign out/i)
      assert find("a", text: /Sign in/i)
    end

    def must_be_signed_in
      assert page.has_content?(/Sign out/i)
      assert !page.has_content?(/Sign in/i)
    end
  end
end