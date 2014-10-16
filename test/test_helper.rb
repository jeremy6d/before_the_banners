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
end

PASSWORD = "testest123"