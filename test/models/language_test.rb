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

  test "index on create" do
    reset_index
    name = SecureRandom.hex(8)
    assert Language.create name: name

    sleep 1
    res = Search::LanguageSearch.new.search q: name
    assert_equal 1, res.total_hits
    assert_equal name, res.sources.first['name']
  end

  test "remove from index on destroy" do
    reset_index
    name = SecureRandom.hex(8)
    obj = Language.create name: name

    sleep 1
    res = Search::LanguageSearch.new.search q: name
    assert_equal 1, res.total_hits

    obj.destroy

    sleep 1
    res = Search::LanguageSearch.new.search q: name
    assert_equal 0, res.total_hits
  end

  test "reviewable" do
    assert_equal ReviewStatus.not_reviewed, Language.new.review_status
  end

  def reset_index
    @index ||= Search::Indexes::LanguageIndex.new.reset_index!
  end
end
