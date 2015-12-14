ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'database_cleaner'
require 'rails/test_help'
require 'capybara/rails'
require 'sidekiq/testing'
require 'shoulda/context'
require 'shoulda/matchers'

Capybara.javascript_driver = :poltergeist
Warden.test_mode!
Sidekiq::Testing.inline!

class ActiveSupport::TestCase
  fixtures :all
end

class ActionDispatch::IntegrationTest
  include Capybara::DSL
  include Warden::Test::Helpers

  def setup
    super
    DatabaseCleaner.start
  end

  def teardown
    super
    Sidekiq::Worker.clear_all
    DatabaseCleaner.clean
  end
end
