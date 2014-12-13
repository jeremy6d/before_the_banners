require_relative "../test_helper"
Dir.glob("#{Rails.root}/test/features/helpers/*\.rb") { |f| require f }

class Capybara::Rails::TestCase
  include Capybara::DSL
  include ::FeatureHelpers::EmailHelpers
  include ::FeatureHelpers::DatepickerHelpers
  include ::FeatureHelpers::ProjectHelpers
  include ::FeatureHelpers::AccountHelpers

  Capybara.default_driver = :webkit
  DatabaseCleaner.strategy = :truncation

  def setup
    # %x[bundle exec rake assets:precompile]
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
    saop and binding.pry
  end

  def screenshot!
    if Capybara.current_driver == :webkit
      screenshot_path = File.join(Rails.root, "tmp", "capybara", "#{Time.now.to_i}.png")
      page.driver.save_screenshot screenshot_path
      Launchy.open screenshot_path, application: "Safari"
    else
      puts "screenshot not supported by driver #{Capybara.current_driver}"
    end
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
    assert page.current_path == desired_path
  end
end