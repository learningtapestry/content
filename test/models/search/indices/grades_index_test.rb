require 'securerandom'
require 'test_helper'

module Search
  module Indices
    class GradesIndexTest < ActiveSupport::TestCase
      @@initial_setup = true

      setup do
        index = GradesIndex.new
        if @@initial_setup || !index.index_exists?
          index.reset_index!
          @@initial_setup = false
        end
      end

      test "#type_name" do
        index = GradesIndex.new
        assert_equal 'grade', index.type_name
      end

      test "#index_name is composed with type and environment" do
        index = GradesIndex.new
        assert_equal 'grades__test', index.index_name
      end

      test '#create_index! creates a new index' do
        index = GradesIndex.new
        index.delete_index!
        refute index.index_exists?

        index.create_index!
        assert index.index_exists?
      end

      test '#delete_index! deletes an index' do
        index = GradesIndex.new
        index.create_index!
        assert index.index_exists?

        index.delete_index!
        refute index.index_exists?
      end

      test "defines mappings and settings" do
        index = GradesIndex.new
        resp = JSON.parse(Faraday.new(:url => "#{es_url}/#{index.index_name}/_mappings").get.body)
        assert_kind_of Hash, resp[index.index_name]['mappings'][index.type_name]

        resp = JSON.parse(Faraday.new(:url => "#{es_url}/#{index.index_name}/_settings").get.body)
        assert_kind_of Hash, resp[index.index_name]['settings']
      end

      test "#serializer points to the corresponding model ActiveModel::Serializer" do
        index = GradesIndex.new
        assert_equal GradeSerializer, index.serializer
      end

      test '#save' do
        index = GradesIndex.new
        name = SecureRandom.hex(8)
        grade = Grade.create name: name, review_status: ReviewStatus.reviewed

        index.save(grade)
        refresh_indices

        resp = JSON.parse(Faraday.new(:url => "#{es_url}/#{index.index_name}/_search?q=name:#{name}").get.body)
        assert_equal 1, resp['hits']['total']
        assert_equal name, resp['hits']['hits'].first['_source']['name']
      end

      test '#after_save' do
        index = GradesIndex.new
        grade = grades(:grade_1)

        def index.after_save(obj, res)
          @after_save_called = true
        end

        index.save(grade)
        assert index.instance_variable_get(:@after_save_called)
      end

      test '#delete' do
        index = GradesIndex.new
        name = SecureRandom.hex(8)
        grade = Grade.create name: name
        index.save(grade)
        refresh_indices

        resp = JSON.parse(Faraday.new(:url => "#{es_url}/#{index.index_name}/_search?q=name:#{name}").get.body)
        assert_equal 1, resp['hits']['total']

        assert index.delete(grade)
        refresh_indices

        resp = JSON.parse(Faraday.new(:url => "#{es_url}/#{index.index_name}/_search?q=name:#{name}").get.body)
        assert_equal 0, resp['hits']['total']
      end

      test '#after_delete' do
        index = GradesIndex.new
        name = SecureRandom.hex(8)
        grade = Grade.create name: name
        index.save(grade)
        refresh_indices

        resp = JSON.parse(Faraday.new(:url => "#{es_url}/#{index.index_name}/_search?q=name:#{name}").get.body)
        assert_equal 1, resp['hits']['total']

        def index.after_delete(obj, res)
          @after_delete_called = true
        end

        assert index.delete(grade)
        assert index.instance_variable_get(:@after_delete_called)
      end
    end
  end
end
