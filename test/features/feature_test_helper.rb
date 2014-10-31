require_relative "../test_helper"

class Capybara::Rails::TestCase
  include Capybara::DSL
  Capybara.default_driver = :webkit
  DatabaseCleaner.strategy = :truncation

  def setup
    %x[bundle exec rake assets:precompile]
    DatabaseCleaner.start
    super
  end

  def teardown
    super
    DatabaseCleaner.clean
  end
  
  def saop
    save_and_open_page
  end

  def enter
    saop and save_and_open_page
  end

  def must_receive_email opts_to_check = {}
    ActionMailer::Base.deliveries.
                       select { |i|
                        opts_to_check.all? do |key, value|
                          actual = i.send(key)
                          case actual.class.to_s
                          when "Mail::AddressContainer"
                            actual.include? value
                          else
                            actual == value
                          end 
                        end
                      }.wont_be :empty?
  end

  def screenshot!
    if Capybara.current_driver == :webkit
      screenshot_path = File.join(Rails.root, "tmp", "capybara", "#{Time.now.to_i}.png")
      page.driver.save_screenshot screenshot_path
      Launchy.open screenshot_path
    else
      puts "screenshot not supported by driver #{Capybara.current_driver}"
    end
  end

  %w(alert notice).each do |type|
    define_method "the_flash_#{type}_must_be" do |msg|
      assert find("ul#flash li.#{type}").has_content?(msg)
    end
  end

  def open_email_addressed_to addr
    @email_body = ActionMailer::Base.deliveries.
                                     select { |e| e.to == addr }.
                                     last.
                                     try :body
  end

  def click_email_link_for message
    visit email_body.match(/<a href="http:\/\/localhost:3000(.*)">#{message}<\/a>/).
                     captures.
                     first
  end

  def email_body
    @email_body ||= ActionMailer::Base.deliveries.last.body
  end

  def confirm_dialog!
    page.driver.browser.accept_js_confirms
  end

  def sign_out!
    visit root_path
    click_on "Sign out" if page.has_content?(/Sign out/i)
    page.wont_have_content /Sign out/i
  end

  def must_be_on desired_path
    page.current_path.must_equal desired_path
  end

  def an_email_was_sent_with attrs = {}
    ActionMailer::Base.deliveries.last.tap do |email|
      attrs.each do |method, value|
        email.send(method).must_include value
      end
    end
  end

  def sign_out!
    click_on "Sign out" if page.has_content?("Sign out")
  end

  def pick_date locator, sought_date
    sought_date = Date.parse(sought_date.to_s) unless sought_date.is_a? Date

    sought_month_and_year = Date.new sought_date.year, sought_date.month, 1

    find('label', text: locator).click

    within("#ui-datepicker-div") do
      current_month_and_year = Date.parse find(".ui-datepicker-title").text

      while (current_month_and_year = Date.parse(find(".ui-datepicker-title").text)) != sought_month_and_year
        case 
        when current_month_and_year > sought_month_and_year
          find(".ui-datepicker-header a", text: "Prev").click
        when current_month_and_year < sought_month_and_year
          find(".ui-datepicker-header a", text: "Next").click
        else
          raise "error state reached"
        end
      end

      find("a", text: /^#{sought_date.day}$/).click
    end
  end

  def create_project! in_attrs = {}
    click_on "My projects"
    click_on "Create new project"

    attrs = Fabricate.attributes_for(:project).merge in_attrs

    fill_in "Project title", with: attrs[:title]
    fill_in "Project value", with: attrs[:value]
    fill_in "Project type", with: attrs[:type]
    fill_in "Project description", with: attrs[:description]
    fill_in "Owner", with: attrs[:owner_title]
    fill_in "Architect", with: attrs[:architect_title]
    fill_in "Builder", with: attrs[:builder_title]
    pick_date "Start date", attrs[:starts_at]
    pick_date "End date", attrs[:ends_at]
    attach_file "project_logo", File.join(Rails.root, "test", "fixtures", "logo.png")
    click_on "Save"
    sleep 1
    return Project.last
  end

  # pass signed up user into the block
  # return false in the block to skip sign out
  def sign_up! attrs = {}, &block
    sign_out!
    user_attrs = Fabricate.attributes_for(:user).merge attrs
    visit "/"
    within("header"){ click_on "Sign up" }
    within("form") do
      fill_in "Company email address", with: user_attrs[:email]
      fill_in "First name", with: user_attrs[:first_name]
      fill_in "Last name", with: user_attrs[:last_name]
      fill_in "user_password", with: PASSWORD
      fill_in "user_password_confirmation", with: PASSWORD
      fill_in "Company name", with: user_attrs[:company_attributes][:title]

      click_on "Sign up"
    end

    the_flash_notice_must_be "Welcome! You have signed up successfully."

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

  def add_workspaces! *names
    edit_project!
    page.click_on "Manage workspaces"

    names.each do |name|
      click_on "New workspace"
      within("form") do
        fill_in "Title", with: name
        click_on "Save"
      end
      click_on "Back"
    end

    click_on "Back to project"
  end

  def set_authorizations_for! user, *labels
    user_name = case user.class.to_s
    when "User"
      user.full_name
    when "String"
      user
    else
      raise "unidentified input in #set_authorizations_for!"
    end

    labels.map! { |l| l.capitalize.gsub "_", " " }

    edit_project!
    click_on "Authorization settings"

    within("tr#authorizations-#{user.to_param}") do
      Authorization.types.each_with_index do |auth, i|
        if labels[i] == auth
          binding.pry
        end
      end
    end
  end

  def invite_to! project, email, *labels
    click_on "Invite new users"
    fill_in "Email", with: email
    within("tr#authorizations-#{project.to_param}") do
      check project.title
      Authorization.types.
                    map { |l| l.capitalize.gsub "_", " " }.
                    each_with_index do |current_auth, i|
        all("input[type='checkbox']")[i + 1].set labels.include?(current_auth)
      end
    end

    click_on "Send invitation"
  end

  def edit_project! project = nil
    unless project.nil?
      find("header").click_on "My projects"
      find("ul li#project-#{project.to_param}").click
    end

    click_on "Edit"
  end

  def add_update_to! project, in_attrs = {}
    click_on "My projects"
    click_on project.title
    click_on "Add update"

    attrs = Fabricate.attributes_for(:update).tap do |a|
      a.merge! in_attrs
      a.delete("author_id")
    end
  id = attrs.delete('workspace_id')
  title = if name = attrs.delete('workspace')
    attrs.delete 'workspace_id'
    Workspace.where(title: name).first
  elsif id
    Workspace.find(id)
  else
    nil
  end.try :title

    select title, from: "Workspace" if title
    attrs.each do |attr_name, attr_value|
      fill_in "update_#{attr_name}", with: attr_value
    end
    
    click_on "Submit update"
  end
end