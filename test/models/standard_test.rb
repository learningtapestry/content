require 'test_helper'

class StandardTest < ActiveSupport::TestCase
  setup do
    @repo = repositories(:khan)
  end

  test '.reconcile creates a new standard' do
    assert_difference 'Standard.count', +1 do
      standard = Standard.reconcile(@repo, 'test standard')[0]
      assert_equal 'test standard', standard.name
    end
  end

  test '.reconcile finds existing standard' do
    assert_no_difference 'Standard.count' do
      standard = Standard.reconcile(@repo, 'ccls.1.2')[0]
      assert_equal 'ccls.1.2', standard.name
    end
  end

  test '.reconcile reuses standard mapping' do
    assert_difference 'ValueMapping.count', +1 do
      assert_no_difference 'Standard.count' do
        standard = Standard.reconcile(@repo, 'ccls.1.2')[0]
        assert_equal 'ccls.1.2', standard.name
      end
    end

    assert_no_difference 'ValueMapping.count' do
      Standard.reconcile(@repo, 'ccls.1.2')
    end
  end
end
