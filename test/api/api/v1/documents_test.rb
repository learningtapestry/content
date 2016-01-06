require 'test_helper'

class API::V1::DocumentsTest < APITest
  setup do
    DocumentImport.create!(
      repository: repositories(:api_docs),
      file: File.new(File.join(fixture_path, 'document_import', 'api_docs.csv'))
    ).process
  end

  test 'GET /api/documents requires an API key' do
    get '/api/v1/documents'
    assert_equal 401, last_response.status
  end

  test 'GET /api/documents works when API key is provided' do
    set_api_key
    get '/api/v1/documents'
    assert last_response.ok?
  end
end
