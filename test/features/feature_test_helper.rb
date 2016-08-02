require_relative "../test_helper"
require 'capybara/poltergeist'
Dir.glob("#{Rails.root}/test/features/helpers/*\.rb") { |f| require f }

class Capybara::Rails::TestCase
  include Capybara::DSL
  include ::FeatureHelpers::EmailHelpers
  include ::FeatureHelpers::DatepickerHelpers
  include ::FeatureHelpers::ProjectHelpers
  include ::FeatureHelpers::AccountHelpers

  
  Capybara.register_driver :poltergeist_debug do |app|
    Capybara::Poltergeist::Driver.new(app, :inspector => true,window_size: [1280, 600])
  end

  Capybara.javascript_driver = Capybara.current_driver = :poltergeist_debug
  DatabaseCleaner.strategy = :truncation

  def setup
    # page.driver.allow_url("fonts.googleapis.com")
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

  def enter!
    saop 
    screenshot!
    binding.pry
  end

  def screenshot!
    screenshot_path = File.join(Rails.root, "tmp", "capybara", "#{Time.now.to_i}.png")
    page.driver.save_screenshot screenshot_path
    Launchy.open screenshot_path, application: "Safari"
  end

  alias_method :ss, :screenshot!

  %w(alert notice).each do |type|
    define_method "the_flash_#{type}_must_be" do |msg|
      assert find("ul#flash li.#{type}").has_content?(msg)
    end
  end

  def confirm_dialog!
    page.driver.browser.accept_js_confirms
  end

  def must_be_on desired_path
    Timeout::timeout(5) do
      while page.current_path != desired_path
        sleep 0.5
      end
      return assert(true)
    end

    assert false, "expected #{desired_path}, got #{page.current_path}"
  end
end