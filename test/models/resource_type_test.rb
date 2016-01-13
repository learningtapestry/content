require 'test_helper'

class ResourceTypeTest < ActiveSupport::TestCase
  setup do
    @repo = repositories(:khan)
  end

  test '.reconcile creates a new resource_type' do
    assert_difference 'ResourceType.count', +1 do
      resource_type = ResourceType.reconcile(@repo, 'test resource_type')[0]
      assert_equal 'test resource_type', resource_type.name
    end
  end

  test '.reconcile finds existing resource_type' do
    assert_no_difference 'ResourceType.count' do
      resource_type = ResourceType.reconcile(@repo, 'lesson')[0]
      assert_equal 'lesson', resource_type.name
    end
  end

  test '.reconcile reuses resource_type mapping' do
    assert_difference 'ValueMapping.count', +1 do
      assert_no_difference 'ResourceType.count' do
        resource_type = ResourceType.reconcile(@repo, 'lesson')[0]
        assert_equal 'lesson', resource_type.name
      end
    end

    assert_no_difference 'ValueMapping.count' do
      ResourceType.reconcile(@repo, 'lesson')
    end
  end
end
