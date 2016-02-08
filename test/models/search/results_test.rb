require 'securerandom'
require 'test_helper'

module Search
  class ResultsTest < ActiveSupport::TestCase
    setup do
      delete_indices
      setup_index
    end

    def setup_index
      index = Indexes::GradeIndex.new
      index.create_index!
      sleep 0.5 # wait for ES to perform operation
      objects = [:grade_1, :grade_2, :grade_K].map { |key| grades(key) }
      index.bulk_index objects
      sleep 1 # wait for ES to perform operation
    end

    test "#results" do
      res = GradeSearch.new.search q: 'grade'
      refute_nil res.results
      assert_kind_of Hash, res.results
    end

    test "#total_hits" do
      res = GradeSearch.new.search q: 'grade'
      assert_equal 3, res.total_hits
    end

    test "#result_key" do
      res = GradeSearch.new.search q: 'grade'
      assert_equal :grades, res.result_key
    end

    test "#records" do
      res = GradeSearch.new.search q: 'grade'
      assert_equal 3, res.records.count
      assert_kind_of Grade, res.records.first
    end

    test "#hits" do
      res = GradeSearch.new.search q: 'grade'
      assert_equal 3, res.hits.count
      hit = res.hits.first
      assert hit._score > 0
      assert_kind_of Hash, hit._source
    end

    test "#sources" do
      res = GradeSearch.new.search q: 'grade'
      source = res.sources.first
      assert_kind_of Hash, source
      assert_includes source.keys, 'name'
      assert_includes source.keys, 'id'
    end

  end
end
