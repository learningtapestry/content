require 'test_helper'

class UrlTest < ActiveSupport::TestCase
  test '.find_root' do
    parent = Url.create(url: 'http://www.parent.com')
    Url.create(url: 'http://www.child.com', parent: parent)

    assert_equal parent, Url.find_root('http://www.child.com')
  end
end
