require 'test_helper'

class GradeTest < ActiveSupport::TestCase
  setup do
    @repo = repositories(:khan)
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
end
