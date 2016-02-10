require 'test_helper'

module Search
  class SubjectSearchTest < ActiveSupport::TestCase
    @@initial_setup = true

    setup do
      index = Indices::SubjectsIndex.new
      if @@initial_setup || !index.index_exists?
        index.reset_index!
        @@initial_setup = false
      end
    end

    def index_objects
      objects = ['math', 'chemistry', 'history'].map do |name|
        Subject.create(name: name, review_status: ReviewStatus.reviewed)
      end
      Indices::SubjectsIndex.new.bulk_index objects
      refresh_indices
    end

    test "#index_name" do
      s = SubjectSearch.new
      assert_equal 'subjects__test', s.index_name
    end

    test "#type_name" do
      s = SubjectSearch.new
      assert_equal 'subject', s.type_name
    end

    test "#search" do
      index_objects
      res = SubjectSearch.new.search q: 'mat'
      assert_equal 'math', res.sources.first['name']

      res = SubjectSearch.new.search q: 'che'
      assert_equal 'chemistry', res.sources.first['name']
    end

    test "parse results" do
      index_objects
      res = SubjectSearch.new.search q: 'his'
      assert_kind_of ::Search::Results, res
    end
  end
end
