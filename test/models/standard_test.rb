require 'test_helper'

class StandardTest < ActiveSupport::TestCase
  setup do
    @repo = repositories(:khan)
  end

  test '.reconciler' do
    assert_kind_of StandardReconciler, Standard.reconciler
  end

  test '.reconcile creates a new standard' do
    assert_difference 'Standard.count', +1 do
      standard = Standard.reconcile(repository: @repo, value: 'test standard')[0]
      assert_equal 'test standard', standard.name
    end
  end

  test '.reconcile finds existing standard' do
    assert_no_difference 'Standard.count' do
      standard = Standard.reconcile(repository: @repo, value: 'ccls.1.2')[0]
      assert_equal 'ccls.1.2', standard.name
    end
  end

  test '.reconcile reuses standard mapping' do
    assert_difference 'ValueMapping.count', +1 do
      assert_no_difference 'Standard.count' do
        standard = Standard.reconcile(repository: @repo, value: 'ccls.1.2')[0]
        assert_equal 'ccls.1.2', standard.name
      end
    end

    assert_no_difference 'ValueMapping.count' do
      Standard.reconcile(repository: @repo, value: 'ccls.1.2')
    end
  end

  test '#search_index points to Index class' do
    assert_kind_of  Search::Indexes::StandardIndex, Standard.new.search_index
  end

end
