require 'test_helper'

class ApiKeyTest < ActiveSupport::TestCase
  test '#generate_key' do
    ak = ApiKey.new
    assert_nil ak.key

    ak.generate_key

    assert ak.key.size > 30
  end

  test '#expire!' do
    ak = ApiKey.new(organization: Organization.first)
    ak.generate_key
    ak.save
    refute ak.expired

    ak.expire!
    ak.reload

    assert ak.expired
  end
end
