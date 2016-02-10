require 'securerandom'
require 'test_helper'

module Search
  module Indices
    class ResourceTypesIndexTest < ActiveSupport::TestCase
      @@initial_setup = true

      setup do
        index = ResourceTypesIndex.new
        if @@initial_setup || !index.index_exists?
          index.reset_index!
          @@initial_setup = false
        end
      end

      test "#type_name" do
        index = ResourceTypesIndex.new
        assert_equal 'resource_type', index.type_name
      end

      test "#index_name is composed with type and environment" do
        index = ResourceTypesIndex.new
        assert_equal 'resource_types__test', index.index_name
      end

      test '#create_index! creates a new index' do
        index = ResourceTypesIndex.new
        index.delete_index!
        refute index.index_exists?

        index.create_index!
        assert index.index_exists?
      end

      test '#delete_index! deletes an index' do
        index = ResourceTypesIndex.new
        index.create_index!
        assert index.index_exists?

        index.delete_index!
        refute index.index_exists?
      end

      test "defines mappings and settings" do
        index = ResourceTypesIndex.new
        resp = JSON.parse(Faraday.new(:url => "#{es_url}/#{index.index_name}/_mappings").get.body)
        assert_kind_of Hash, resp[index.index_name]['mappings'][index.type_name]

        resp = JSON.parse(Faraday.new(:url => "#{es_url}/#{index.index_name}/_settings").get.body)
        assert_kind_of Hash, resp[index.index_name]['settings']
      end

      test "#serializer points to the corresponding model ActiveModel::Serializer" do
        index = ResourceTypesIndex.new
        assert_equal ResourceTypeSerializer, index.serializer
      end

      test '#save' do
        index = ResourceTypesIndex.new
        name = SecureRandom.hex(8)
        resource_type = ResourceType.create name: name
        index.save(resource_type)
        refresh_indices

        resp = JSON.parse(Faraday.new(:url => "#{es_url}/#{index.index_name}/_search?q=name:#{name}").get.body)
        assert_equal 1, resp['hits']['total']
        assert_equal name, resp['hits']['hits'].first['_source']['name']
      end

      test '#after_save' do
        index = ResourceTypesIndex.new
        resource_type = resource_types(:lesson)

        def index.after_save(obj, res)
          @after_save_called = true
        end

        index.save(resource_type)
        assert index.instance_variable_get(:@after_save_called)
      end

      test '#delete' do
        index = ResourceTypesIndex.new
        name = SecureRandom.hex(8)
        resource_type = ResourceType.create name: name
        index.save(resource_type)
        refresh_indices

        resp = JSON.parse(Faraday.new(:url => "#{es_url}/#{index.index_name}/_search?q=name:#{name}").get.body)
        assert_equal 1, resp['hits']['total']

        assert index.delete(resource_type)
        refresh_indices

        resp = JSON.parse(Faraday.new(:url => "#{es_url}/#{index.index_name}/_search?q=name:#{name}").get.body)
        assert_equal 0, resp['hits']['total']
      end

      test '#after_delete' do
        index = ResourceTypesIndex.new
        name = SecureRandom.hex(8)
        resource_type = ResourceType.create name: name
        index.save(resource_type)
        refresh_indices

        resp = JSON.parse(Faraday.new(:url => "#{es_url}/#{index.index_name}/_search?q=name:#{name}").get.body)
        assert_equal 1, resp['hits']['total']

        def index.after_delete(obj, res)
          @after_delete_called = true
        end

        assert index.delete(resource_type)
        assert index.instance_variable_get(:@after_delete_called)
      end
    end
  end
end
