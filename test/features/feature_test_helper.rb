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

  def sign_in_as! usr
    visit new_user_session_path
    
    within("form#new_user") do
      fill_in "Email", with: usr.email
      fill_in "Password", with: PASSWORD
      click_on "Sign in"
    end

    the_flash_notice_must_be "Signed in successfully."
  end
end