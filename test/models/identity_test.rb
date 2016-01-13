require 'test_helper'

class IdentityTest < ActiveSupport::TestCase
  setup do
    @repo = repositories(:khan)
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

end
