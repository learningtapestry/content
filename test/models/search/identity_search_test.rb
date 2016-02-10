require 'test_helper'

module Search
  class IdentitySearchTest < ActiveSupport::TestCase
    @@initial_setup = true

    setup do
      index = Indices::IdentitiesIndex.new
      if @@initial_setup || !index.index_exists?
        index.reset_index!
        @@initial_setup = false
      end
    end

    def index_objects
      objects = [:khan, :jason].map { |key| identities(key) }
      Indices::IdentitiesIndex.new.bulk_index objects
      refresh_indices
    end

    test "#index_name" do
      s = IdentitySearch.new
      assert_equal 'identities__test', s.index_name
    end

    test "#type_name" do
      s = IdentitySearch.new
      assert_equal 'identity', s.type_name
    end

    test "#search" do
      index_objects
      res = IdentitySearch.new.search q: 'jas'
      assert_equal 'Jason', res.sources.first['name']

      res = IdentitySearch.new.search q: 'kh'
      assert_equal 'Khan Academy', res.sources.first['name']
    end

    test "parse results" do
      index_objects
      res = IdentitySearch.new.search q: 'jas'
      assert_kind_of ::Search::Results, res
    end
  end
end
