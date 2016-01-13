require 'test_helper'

class UrlTest < ActiveSupport::TestCase
  setup do
    @repo = repositories(:khan)
  end

  test '.find_root' do
    parent = Url.create(url: 'http://www.parent.com')
    Url.create(url: 'http://www.child.com', parent: parent)

    assert_equal parent, Url.find_root('http://www.child.com')
  end

  test '.reconcile creates a new url' do
    assert_difference 'Url.count', +1 do
      url = Url.reconcile(repository: @repo, value: 'http://www.test.com')[0]
      assert_equal 'http://www.test.com', url.url
    end
  end

  test '.reconcile finds existing url' do
    khan = urls(:khan_intro_algebra).url

    assert_no_difference 'Url.count' do
      url = Url.reconcile(repository: @repo, value: khan)[0]
      assert_equal khan, url.url
    end
  end

  test '.reconcile reuses url mapping' do
    khan = urls(:khan_intro_algebra).url

    assert_difference 'ValueMapping.count', +1 do
      assert_no_difference 'Url.count' do
        url = Url.reconcile(repository: @repo, value: khan)[0]
        assert_equal khan, url.url
      end
    end

    assert_no_difference 'ValueMapping.count' do
      Url.reconcile(repository: @repo, value: khan)
    end
  end
end
