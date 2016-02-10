require 'test_helper'

class SubjectTest < ActiveSupport::TestCase
  setup do
    @repo = repositories(:khan)
  end

  test ".reconciler" do
    assert_kind_of SubjectReconciler, Subject.reconciler
  end

  test '.reconcile creates a new subject' do
    assert_difference 'Subject.count', +1 do
      subject = Subject.reconcile(repository: @repo, value: 'test subject')[0]
      assert_equal 'test subject', subject.name
    end
  end

  test '.reconcile finds existing subject' do
    assert_no_difference 'Subject.count' do
      subject = Subject.reconcile(repository: @repo, value: 'history')[0]
      assert_equal 'history', subject.name
    end
  end

  test '.reconcile reuses subject mapping' do
    assert_difference 'ValueMapping.count', +1 do
      assert_no_difference 'Subject.count' do
        subject = Subject.reconcile(repository: @repo, value: 'history')[0]
        assert_equal 'history', subject.name
      end
    end

    assert_no_difference 'ValueMapping.count' do
      Subject.reconcile(repository: @repo, value: 'history')
    end
  end

  test '#search_index points to Index class' do
    assert_kind_of  Search::Indices::SubjectsIndex, Subject.new.search_index
  end

  test "index on create" do
    reset_index
    name = SecureRandom.hex(8)
    assert Subject.create name: name

    refresh_indices
    res = Search::SubjectSearch.new.search q: name
    assert_equal 1, res.total_hits
    assert_equal name, res.sources.first['name']
  end

  test "remove from index on destroy" do
    reset_index
    name = SecureRandom.hex(8)
    obj = Subject.create name: name

    refresh_indices
    res = Search::SubjectSearch.new.search q: name
    assert_equal 1, res.total_hits

    obj.destroy

    refresh_indices
    res = Search::SubjectSearch.new.search q: name
    assert_equal 0, res.total_hits
  end

  test "reviewable" do
    assert_equal ReviewStatus.not_reviewed, Subject.new.review_status
  end

  def reset_index
    @index ||= Search::Indices::SubjectsIndex.new.reset_index!
  end
end
