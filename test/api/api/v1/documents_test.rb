require 'test_helper'

class API::V1::DocumentsTest < APITest
  test 'GET /api/documents requires an API key' do
    get '/api/v1/documents'
    assert_equal 401, last_response.status
  end

  test 'GET /api/documents works when API key is provided' do
    set_api_key
    get '/api/v1/documents'
    assert last_response.ok?
  end

  test 'GET /api/documents/?q= performs a full text search' do
    set_api_key
    import_docs
    get '/api/v1/documents', q: 'algebra'
    assert_equal 1, last_json.size
    assert_match (/algebra/i), last_json.first['title']
  end

  test 'GET /api/documents/?title= performs a full text search' do
    set_api_key
    import_docs
    get '/api/v1/documents', title: 'algebra'
    assert_equal 1, last_json.size
    assert_match (/algebra/i), last_json.first['title']
  end

  test 'GET /api/documents/?description= performs a full text search' do
    set_api_key
    import_docs
    get '/api/v1/documents', description: 'algebra'
    assert_equal 1, last_json.size
    assert_match (/algebra/i), last_json.first['description']
  end

  test 'GET /api/documents/?grade_id= finds docs with specified grade' do
    set_api_key
    import_docs
    grade = repositories(:api_docs).documents.first.grades.first

    get '/api/v1/documents', grade_id: grade.id

    assert_equal 1, last_json.size
    assert last_json.first['grades'].any? { |g| g['id'] == grade.id }
  end

  test 'GET /api/documents/?grade_name= finds docs with specified grade' do
    set_api_key
    import_docs

    get '/api/v1/documents', grade_name: 'grade 1'

    assert_equal 1, last_json.size
    assert last_json.first['grades'].any? { |g| g['name'] == 'Grade 1' }
  end

  def import_docs
    delete_indices

    DocumentImport.create!(
      repository: repositories(:api_docs),
      file: File.new(File.join(fixture_path, 'document_import', 'api_docs.csv'))
    ).process

    refresh_indices
  end
end
