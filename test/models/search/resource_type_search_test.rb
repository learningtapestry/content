require 'test_helper'

module Search
  class ResourceTypeSearchTest < ActiveSupport::TestCase
    @@initial_setup = true

    setup do
      index = Indices::ResourceTypeIndex.new
      if @@initial_setup || !index.index_exists?
        index.reset_index!
        @@initial_setup = false
      end
    end

    def index_objects
      objects = ['lesson', 'video', 'quiz'].map do |name|
        ResourceType.create(name: name, review_status: ReviewStatus.reviewed)
      end
      Indices::ResourceTypeIndex.new.bulk_index objects
      refresh_indices
    end

    test "#index_name" do
      s = ResourceTypeSearch.new
      assert_equal 'resource_types__test', s.index_name
    end

    test "#type_name" do
      s = ResourceTypeSearch.new
      assert_equal 'resource_type', s.type_name
    end

    test "#search" do
      index_objects
      res = ResourceTypeSearch.new.search q: 'leso'
      assert_equal 'lesson', res.sources.first['name']

      res = ResourceTypeSearch.new.search q: 'qiz'
      assert_equal 'quiz', res.sources.first['name']
    end

    test "parse results" do
      index_objects
      res = ResourceTypeSearch.new.search q: 'les'
      assert_kind_of ::Search::Results, res
    end
  end
end
