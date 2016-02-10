require 'test_helper'

class IdentityTest < ActiveSupport::TestCase
  setup do
    @repo = repositories(:khan)
  end

  test '.reconciler' do
    assert_kind_of IdentityReconciler, Identity.reconciler
  end

  test '.reconcile creates a new publisher' do
    assert_difference 'Identity.count', +1 do
      publisher = Identity.reconcile(repository: @repo, value: 'test publisher')[0]
      assert_equal 'test publisher', publisher.name
    end
  end

  test '.reconcile finds existing publisher' do
    assert_no_difference 'Identity.count' do
      publisher = Identity.reconcile(repository: @repo, value: 'Khan Academy')[0]
      assert_equal 'Khan Academy', publisher.name
    end
  end

  test '.reconcile reuses publisher mapping' do
    assert_difference 'ValueMapping.count', +1 do
      assert_no_difference 'Identity.count' do
        publisher = Identity.reconcile(repository: @repo, value: 'Khan Academy')[0]
        assert_equal 'Khan Academy', publisher.name
      end
    end

    assert_no_difference 'ValueMapping.count' do
      Identity.reconcile(repository: @repo, value: 'Khan Academy')
    end
  end

  test '#search_index points to Index class' do
    assert_kind_of  Search::Indices::IdentitiesIndex, Identity.new.search_index
  end

  test "index on create" do
    reset_index
    name = SecureRandom.hex(8)
    assert Identity.create name: name

    refresh_indices
    res = Identity.search name
    assert_equal 1, res.total_hits
    assert_equal name, res.sources.first['name']
  end

  test "remove from index on destroy" do
    reset_index
    name = SecureRandom.hex(8)
    obj = Identity.create name: name

    refresh_indices
    res = Identity.search name
    assert_equal 1, res.total_hits

    obj.destroy

    refresh_indices
    res = Identity.search name
    assert_equal 0, res.total_hits
  end

  test "reviewable" do
    assert_equal ReviewStatus.not_reviewed, Identity.new.review_status
  end

  def reset_index
    @index ||= Search::Indices::IdentitiesIndex.new.reset_index!
  end
end
