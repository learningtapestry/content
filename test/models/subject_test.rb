require 'test_helper'

class SubjectTest < ActiveSupport::TestCase
  setup do
    @repo = repositories(:khan)
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
end
