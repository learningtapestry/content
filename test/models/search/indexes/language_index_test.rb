require 'securerandom'
require 'test_helper'

module Search
  module Indexes
    class LanguageIndexTest < ActiveSupport::TestCase
      @@initial_setup = true

      setup do
        index = LanguageIndex.new
        if @@initial_setup || !index.index_exists?
          index.reset_index!
          @@initial_setup = false
        end
      end

      test "#type_name" do
        index = LanguageIndex.new
        assert_equal 'language', index.type_name
      end

      test "#index_name is composed with type and environment" do
        index = LanguageIndex.new
        assert_equal 'languages__test', index.index_name
      end

      test '#create_index! creates a new index' do
        index = LanguageIndex.new
        index.delete_index!
        refute index.index_exists?

        index.create_index!
        assert index.index_exists?
      end

      test '#delete_index! deletes an index' do
        index = LanguageIndex.new
        index.create_index!
        assert index.index_exists?

        index.delete_index!
        refute index.index_exists?
      end

      test "defines mappings and settings" do
        index = LanguageIndex.new
        resp = JSON.parse(Faraday.new(:url => "#{es_url}/#{index.index_name}/_mappings").get.body)
        assert_kind_of Hash, resp[index.index_name]['mappings'][index.type_name]

        resp = JSON.parse(Faraday.new(:url => "#{es_url}/#{index.index_name}/_settings").get.body)
        assert_kind_of Hash, resp[index.index_name]['settings']
      end

      test "#serializer points to the corresponding model ActiveModel::Serializer" do
        index = LanguageIndex.new
        assert_equal LanguageSerializer, index.serializer
      end

      test '#save' do
        index = LanguageIndex.new
        name = SecureRandom.hex(8)
        language = Language.create name: name, review_status: ReviewStatus.reviewed

        assert index.save(language)
        sleep 1.0

        resp = JSON.parse(Faraday.new(:url => "#{es_url}/#{index.index_name}/_search?q=name:#{name}").get.body)
        assert_equal 1, resp['hits']['total']
        assert_equal name, resp['hits']['hits'].first['_source']['name']
      end

      test '#after_save' do
        index = LanguageIndex.new
        language = languages(:en)

        def index.after_save(obj, res)
          @after_save_called = true
        end

        assert index.save(language)
        assert index.instance_variable_get(:@after_save_called)
      end

      test '#delete' do
        index = LanguageIndex.new
        name = SecureRandom.hex(8)
        language = Language.create name: name, review_status: ReviewStatus.reviewed

        assert index.save(language)
        sleep 1.0

        resp = JSON.parse(Faraday.new(:url => "#{es_url}/#{index.index_name}/_search?q=name:#{name}").get.body)
        assert_equal 1, resp['hits']['total']

        assert index.delete(language)
        sleep 1.0

        resp = JSON.parse(Faraday.new(:url => "#{es_url}/#{index.index_name}/_search?q=name:#{name}").get.body)
        assert_equal 0, resp['hits']['total']
      end

      test '#after_delete' do
        index = LanguageIndex.new
        name = SecureRandom.hex(8)
        language = Language.create name: name, review_status: ReviewStatus.reviewed

        assert index.save(language)
        sleep 1.0

        resp = JSON.parse(Faraday.new(:url => "#{es_url}/#{index.index_name}/_search?q=name:#{name}").get.body)
        assert_equal 1, resp['hits']['total']

        def index.after_delete(obj, res)
          @after_delete_called = true
        end

        assert index.delete(language)
        assert index.instance_variable_get(:@after_delete_called)
      end
    end
  end
end
