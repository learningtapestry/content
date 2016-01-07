ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'database_cleaner'
require 'rails/test_help'
require 'capybara/rails'
require 'sidekiq/testing'
require 'shoulda/context'
require 'shoulda/matchers'
require 'json'

Capybara.javascript_driver = :poltergeist
Warden.test_mode!
Sidekiq::Testing.inline!

module SearchTest
  def es_url
    ENV['ELASTICSEARCH_URL']
  end

  def es_indices
    indices = JSON.parse(Faraday.new(:url => "#{es_url}/_aliases").get.body)
    indices.keys.select { |k| k.include?('__test') }
  end

  def delete_indices
    es_indices.each do |index|
      Faraday.new(:url => "#{es_url}/#{index}").delete
    end
  end

  def refresh_indices
    es_indices.each do |index|
      Faraday.new(:url => "#{es_url}/#{index}/_refresh").get
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

  def last_json
    JSON.parse(last_response.body)
  end
end
