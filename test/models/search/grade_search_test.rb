require 'test_helper'

module Search
  class GradeSearchTest < ActiveSupport::TestCase
    @@initial_setup = true

    setup do
      index = Indices::GradesIndex.new
      if @@initial_setup || !index.index_exists?
        index.reset_index!
        @@initial_setup = false
      end
    end

    def index_objects
      objects = [:grade_1, :grade_2, :grade_K].map { |key| grades(key) }
      Indices::GradesIndex.new.bulk_index objects
      refresh_indices
    end

    test "#index_name" do
      s = GradeSearch.new
      assert_equal 'grades__test', s.index_name
    end

    test "#type_name" do
      s = GradeSearch.new
      assert_equal 'grade', s.type_name
    end

    test "#search" do
      index_objects
      res = GradeSearch.new.search q: 'grad 2'
      assert_equal 'grade 2', res.sources.first['name']

      res = GradeSearch.new.search q: 'kinder'
      assert_equal 'Kindergarten', res.sources.first['name']
    end

    test "parse results" do
      index_objects
      res = GradeSearch.new.search q: 'grad 2'
      assert_kind_of ::Search::Results, res
    end
  end
end
