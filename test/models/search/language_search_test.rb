require 'test_helper'

module Search
  class LanguageSearchTest < ActiveSupport::TestCase
    @@initial_setup = true

    setup do
      index = Indexes::LanguageIndex.new
      if @@initial_setup || !index.index_exists?
        index.reset_index!
        @@initial_setup = false
      end
    end

    def index_objects
      objects = [:en, :es].map { |key| languages(key) }
      Indexes::LanguageIndex.new.bulk_index objects
      refresh_indices
    end

    test "#index_name" do
      s = LanguageSearch.new
      assert_equal 'languages__test', s.index_name
    end

    test "#type_name" do
      s = LanguageSearch.new
      assert_equal 'language', s.type_name
    end

    test "#search" do
      index_objects
      res = LanguageSearch.new.search q: 'en'
      assert_equal 'en', res.sources.first['name']
      assert_equal 'english', res.sources.first['full_name']

      res = LanguageSearch.new.search q: 'span'
      assert_equal 'es', res.sources.first['name']
      assert_equal 'spanish', res.sources.first['full_name']
    end

    test "parse results" do
      index_objects
      res = LanguageSearch.new.search q: 'en'
      assert_kind_of ::Search::Results, res
    end
  end
end
