require 'test_helper'

class LanguageTest < ActiveSupport::TestCase
  setup do
    @repo = repositories(:khan)
  end

  test '.reconciler' do
    assert_kind_of LanguageReconciler, Language.reconciler
  end

  test '.reconcile creates a new language' do
    assert_difference 'Language.count', +1 do
      language = Language.reconcile(repository: @repo, value: 'ko')[0]
      assert_equal 'ko', language.name
    end
  end

  test '.reconcile finds existing language' do
    assert_no_difference 'Language.count' do
      language = Language.reconcile(repository: @repo, value: 'en')[0]
      assert_equal 'en', language.name
    end
  end

  test '.reconcile reuses language mapping' do
    assert_difference 'ValueMapping.count', +1 do
      assert_no_difference 'Language.count' do
        language = Language.reconcile(repository: @repo, value: 'en')[0]
        assert_equal 'en', language.name
      end
    end

    assert_no_difference 'ValueMapping.count' do
      Language.reconcile(repository: @repo, value: 'en')
    end
  end

  test '#search_index points to Index class' do
    assert_kind_of Search::Indexes::LanguageIndex, Language.new.search_index
  end

end
