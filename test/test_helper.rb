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

module SearchTest
  def delete_test_indices
    es_url = ENV['ELASTICSEARCH_URL']
    indices = JSON.parse(Faraday.new(:url => "#{es_url}/_aliases").get.body).keys
    indices.select { |k| k.include?('__test') }.each do |index|
      Faraday.new(:url => "#{es_url}/#{index}").delete
    end
  end
end

class ActiveSupport::TestCase
  fixtures :all
  include SearchTest
end

class ActionDispatch::IntegrationTest
  include Capybara::DSL
  include Warden::Test::Helpers
  include SearchTest

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

class APITest < ActiveSupport::TestCase
  include Rack::Test::Methods
  include SearchTest

  def app
    Rails.application
  end

  def set_api_key
    header 'X-Api-Key', api_keys(:api_user).key
  end
end
