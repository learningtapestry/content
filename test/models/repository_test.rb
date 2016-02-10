require 'test_helper'

class RepositoryTest < ActiveSupport::TestCase
  test '#search_index returns an ES index' do
    khan = repositories(:khan)
    idx = khan.search_index

    assert_kind_of Search::Indices::DocumentsIndex, idx
    assert_equal khan, idx.repository
  end
end
