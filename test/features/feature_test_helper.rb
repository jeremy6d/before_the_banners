require_relative "../test_helper"

class Capybara::Rails::TestCase
  include Capybara::DSL
  Capybara.default_driver = :webkit
  DatabaseCleaner.strategy = :truncation

  def setup
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
      within("ul#flash li.#{type}") do
        page.must_have_content msg
      end

      page.all("button.ui-dialog-titlebar-close").first.tap do |e|
        e.click if e # close flash dialog
      end
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

  def sign_up_user! in_attrs = {}
    sign_out!
    user_attrs = Fabricate.attributes_for(:user).merge in_attrs
    visit root_path

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

    return User.last
  end

  def sign_out!
    click_on "Sign out" if page.has_content?("Sign out")
  end

  def sign_in_as! usr
    sign_out!
    visit new_user_session_path

    within("form#new_user") do
      fill_in "Email", with: usr.email
      fill_in "Password", with: PASSWORD
      click_on "Sign in"
    end

    the_flash_notice_must_be "Signed in successfully."
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
end