ENV["RAILS_ENV"] ||= "test"
require 'minitest/autorun'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require "minitest/rails/capybara"
require "minitest-matchers"
require 'database_cleaner'
require "minitest/reporters"
Minitest::Reporters.use!

Fabrication.configure do |config|
  config.fabricator_path = 'test/fabricators'
  config.path_prefix = Rails.root
end

require 'mocha/setup'

class ActionController::TestCase
  include Devise::TestHelpers
end

DatabaseCleaner.strategy = :truncation

class MiniTest::Spec
  before :each do
    DatabaseCleaner.start
  end

  after :each do
    DatabaseCleaner.clean
  end
end

PASSWORD = "testest123"