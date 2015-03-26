require File.expand_path('../boot', __FILE__)

# Pick the frameworks you want:
require "active_model/railtie"
# require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "sprockets/railtie"
require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module BeforeTheBanners
  class Application < Rails::Application
    config.encoding = "utf-8"
    config.time_zone = 'Eastern Time (US & Canada)'
    config.active_support.escape_html_entities_in_json = true
    config.assets.enabled = true
    config.assets.version = '1.0'
    config.assets.initialize_on_precompile = false
    config.autoload_paths += %W(#{config.root}/lib)

    config.generators do |gen|
      gen.orm                 :mongoid
      gen.template_engine     :haml
      gen.test_framework      :minitest,  spec: true,
                                          fixture_replacement: :fabrication
      gen.fixture_replacement :fabrication, dir: "test/fabricators"
    end
  end
end
