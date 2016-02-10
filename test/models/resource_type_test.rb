require 'test_helper'

class ResourceTypeTest < ActiveSupport::TestCase
  setup do
    @repo = repositories(:khan)
  end

  test '.reconciler' do
    assert_kind_of ResourceTypeReconciler, ResourceType.reconciler
  end

  test '.reconcile creates a new resource_type' do
    assert_difference 'ResourceType.count', +1 do
      resource_type = ResourceType.reconcile(repository: @repo, value: 'test resource_type')[0]
      assert_equal 'test resource_type', resource_type.name
    end
  end

  test '.reconcile finds existing resource_type' do
    assert_no_difference 'ResourceType.count' do
      resource_type = ResourceType.reconcile(repository: @repo, value: 'lesson')[0]
      assert_equal 'lesson', resource_type.name
    end
  end

  test '.reconcile reuses resource_type mapping' do
    assert_difference 'ValueMapping.count', +1 do
      assert_no_difference 'ResourceType.count' do
        resource_type = ResourceType.reconcile(repository: @repo, value: 'lesson')[0]
        assert_equal 'lesson', resource_type.name
      end
    end

    assert_no_difference 'ValueMapping.count' do
      ResourceType.reconcile(repository: @repo, value: 'lesson')
    end
  end

  test '#search_index points to Index class' do
    assert_kind_of  Search::Indices::ResourceTypeIndex, ResourceType.new.search_index
  end
  test "index on create" do
    reset_index
    name = SecureRandom.hex(8)
    assert ResourceType.create name: name

    refresh_indices
    res = Search::ResourceTypeSearch.new.search q: name
    assert_equal 1, res.total_hits
    assert_equal name, res.sources.first['name']
  end

  test "remove from index on destroy" do
    reset_index
    name = SecureRandom.hex(8)
    obj = ResourceType.create name: name

    refresh_indices
    res = Search::ResourceTypeSearch.new.search q: name
    assert_equal 1, res.total_hits

    obj.destroy

    refresh_indices
    res = Search::ResourceTypeSearch.new.search q: name
    assert_equal 0, res.total_hits
  end

  test "reviewable" do
    assert_equal ReviewStatus.not_reviewed, ResourceType.new.review_status
  end

  def reset_index
    @index ||= Search::Indices::ResourceTypeIndex.new.reset_index!
  end
end
