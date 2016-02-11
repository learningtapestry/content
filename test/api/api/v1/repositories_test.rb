require 'test_helper'

class API::V1::RepositoriesTest < APITest
  setup do
    @new_repo = Repository.create(
      organization: organizations(:api_user),
      name: 'Testing repo',
      public: false
    )
  end

  test 'GET /api/repositories requires an API key' do
    get '/api/v1/repositories'
    assert_equal 401, last_response.status
  end

  test 'GET /api/repositories requires admin role' do
    set_api_key(api_keys(:api_search))
    get '/api/v1/repositories'
    assert_equal 401, last_response.status
  end

  test 'GET /api/repositories works when API key is provided' do
    set_api_key
    get '/api/v1/repositories'
    assert last_response.ok?
  end

  test 'GET /api/repositories lists repositories' do
    set_api_key
    get '/api/v1/repositories'
    assert_equal 2, last_json.size
    assert_same_elements ['API Docs', 'Testing repo'], last_json.map { |j| j['name'] }
  end

  test 'GET /api/repositories paginates repositories' do
    set_api_key
    get '/api/v1/repositories', limit: 1, page: 2
    assert_equal 1, last_json.size
  end

  test 'GET /api/repositories?name= filters repositories' do
    set_api_key

    get '/api/v1/repositories', name: 'Testing'

    assert_equal 1, last_json.size
    assert_match (/Testing/i), last_json.first['name']
  end

  test 'POST /api/repositories creates a repository' do
    set_api_key

    post '/api/v1/repositories', name: 'New docs', public: false

    refute_nil last_json['repository']['id']
    assert_equal 'New docs', last_json['repository']['name']
    assert_equal false     , last_json['repository']['public']
  end

  test 'POST /api/repositories updates a repository' do
    set_api_key

    put "/api/v1/repositories/#{@new_repo.id}", name: 'New docs', public: true
    @new_repo.reload

    assert last_response.ok?
    assert_equal 'New docs', @new_repo.name
    assert_equal true,       @new_repo.public
  end

  test 'DELETE /api/repositories deletes a repository' do
    set_api_key

    delete "/api/v1/repositories/#{@new_repo.id}"

    refute Repository.exists?(@new_repo.id)
  end

end
