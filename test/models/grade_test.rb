require 'test_helper'
require 'securerandom'

class GradeTest < ActiveSupport::TestCase
  setup do
    @repo = repositories(:khan)
  end

  test '.reconciler' do
    assert_kind_of GradeReconciler, Grade.reconciler
  end

  test '.reconcile creates a new grade' do
    assert_difference 'Grade.count', +1 do
      grade = Grade.reconcile(repository: @repo, value: 'test grade')[0]
      assert_equal 'test grade', grade.name
    end
  end

  test '.reconcile finds existing grade' do
    assert_no_difference 'Grade.count' do
      grade = Grade.reconcile(repository: @repo, value: 'grade 1')[0]
      assert_equal 'grade 1', grade.name
    end
  end

  test '.reconcile reuses grade mapping' do
    assert_difference 'ValueMapping.count', +1 do
      assert_no_difference 'Grade.count' do
        grade = Grade.reconcile(repository: @repo, value: 'grade 1')[0]
        assert_equal 'grade 1', grade.name
      end
    end

    assert_no_difference 'ValueMapping.count' do
      Grade.reconcile(repository: @repo, value: 'grade 1')
    end
  end

  test '#search_index points to Index class' do
    assert_kind_of  Search::Indexes::GradeIndex, Grade.new.search_index
  end

  test "index on create" do
    reset_index
    name = SecureRandom.hex(8)
    assert Grade.create name: name

    sleep 1
    res = Search::GradeSearch.new.search q: name
    assert_equal 1, res.total_hits
    assert_equal name, res.sources.first['name']
  end

  test "remove from index on destroy" do
    reset_index
    name = SecureRandom.hex(8)
    grade = Grade.create name: name

    sleep 1
    res = Search::GradeSearch.new.search q: name
    assert_equal 1, res.total_hits

    grade.destroy

    sleep 1
    res = Search::GradeSearch.new.search q: name
    assert_equal 0, res.total_hits
  end

  test "reviewable" do
    assert_equal ReviewStatus.not_reviewed, Grade.new.review_status
  end

  def reset_index
    @index ||= Search::Indexes::GradeIndex.new.reset_index!
  end
end
