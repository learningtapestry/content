require 'test_helper'

module Search
  class StandardSearchTest < ActiveSupport::TestCase
    @@initial_setup = true

    setup do
      index = Indexes::StandardIndex.new
      if @@initial_setup || !index.index_exists?
        index.reset_index!
        @@initial_setup = false
      end
    end

    def index_objects
      Indexes::StandardIndex.new.index standards(:ccls_1_2)
      sleep 1
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
  end
end
