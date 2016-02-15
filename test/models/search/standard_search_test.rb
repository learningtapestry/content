require 'test_helper'

module Search
  class StandardSearchTest < ActiveSupport::TestCase
    @@initial_setup = true

    setup do
      index = Indices::StandardsIndex.new
      if @@initial_setup || !index.index_exists?
        index.reset_index!
        @@initial_setup = false
      end
    end

    def index_objects
      Indices::StandardsIndex.new.index standards(:ccls_1_2)
      refresh_indices
    end

    test "#index_name" do
      s = StandardSearch.new
      assert_equal 'standards__test', s.index_name
    end

    test "#type_name" do
      s = StandardSearch.new
      assert_equal 'standard', s.type_name
    end

    test "#search" do
      index_objects
      res = StandardSearch.new.search q: 'ccls'
      assert_equal 'ccls.1.2', res.sources.first['name']
    end

    test "parse results" do
      index_objects
      res = StandardSearch.new.search q: 'ccls'
      assert_kind_of ::Search::Results, res
    end

    test "search by definitions" do
      Standard.create name: 'CCSS.Math.BLA-1.2', definitions: ['B.1.2', '98765']
      Standard.create name: 'CCSS.Math.BLA-1.3', definitions: ['B.1.3', '65632']
      refresh_indices

      res = StandardSearch.new.search q: 'b.1.2'
      assert_equal 'CCSS.Math.BLA-1.2', res.sources.first['name']

      res = StandardSearch.new.search q: '98765'
      assert_equal 'CCSS.Math.BLA-1.2', res.sources.first['name']
    end
  end
end
