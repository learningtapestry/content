require 'test_helper'

class Refine::ReconcileTest < APITest
  setup do
    # delete_indices
  end

  def query_for(type, term)
    "{\"q0\":{\"query\":\"#{term}\",\"type\":\"#{type}\",\"type_strict\":\"should\"}}"
  end

  test 'GET /refine/reconcile requires a callback param' do
    get '/refine/reconcile'
    assert_equal 400, last_response.status
  end

  test 'GET /refine/reconcile return jsonp response' do
    get '/refine/reconcile?callback=jQuery1234567890&_=2345689654'

    assert_equal 200, last_response.status
    assert_equal 'application/javascript', last_response.content_type
    assert_match(/\/\*\*\/jQuery1234567890(.*)/, last_response.body)
  end

  test 'GET /refine/reconcile returns metadata' do
    get '/refine/reconcile?callback=jQuery1234567890&_=2345689654'

    assert_match(/LT :: Reconciliation/, last_response.body)
    ['Grade', 'Language', 'Identity', 'ResourceType', 'Standard', 'Subject'].each do |service|
      assert_match(/{"id":"#{service}","name":"#{service}"}/, last_response.body)
    end
  end

  test 'POST /refine/reconcile requires a queries param' do
    post '/refine/reconcile'
    assert_equal 400, last_response.status
  end

  test 'POST /refine/reconcile for Grade' do
    [ :grade_1, :grade_2, :grade_K ].each {|key| grades(key).save }
    sleep 1

    post '/refine/reconcile', queries: query_for('Grade', 'grade 1')
    assert_equal 201, last_response.status
    res = JSON.parse(last_response.body)['q0']['result'].first

    assert_equal ['Grade'], res['type']
    assert_equal 'grade 1', res['name']
    assert_equal true, res['match']
  end

  test 'POST /refine/reconcile for Language' do
    [ :en, :es ].each {|key| languages(key).save }
    sleep 1

    post '/refine/reconcile', queries: query_for('Language', 'en_US')
    assert_equal 201, last_response.status
    res = JSON.parse(last_response.body)['q0']['result'].first

    assert_equal ['Language'], res['type']
    assert_equal 'en', res['name']
  end

  test 'POST /refine/reconcile for Identity' do
    [ :jason, :khan ].each {|key| identities(key).save }
    sleep 1

    post '/refine/reconcile', queries: query_for('Identity', 'KHAN acad')
    assert_equal 201, last_response.status
    res = JSON.parse(last_response.body)['q0']['result'].first

    assert_equal ['Identity'], res['type']
    assert_equal 'Khan Academy', res['name']
  end

  test 'POST /refine/reconcile for Subject' do
    [ :history, :chemistry ].each {|key| subjects(key).save }
    sleep 1

    post '/refine/reconcile', queries: query_for('Subject', 'chem.')
    assert_equal 201, last_response.status
    res = JSON.parse(last_response.body)['q0']['result'].first

    assert_equal ['Subject'], res['type']
    assert_equal 'chemistry', res['name']
  end

  test 'POST /refine/reconcile for Standard' do
    standards(:ccls_1_2).save
    sleep 1

    post '/refine/reconcile', queries: query_for('Standard', 'ccls')
    assert_equal 201, last_response.status
    res = JSON.parse(last_response.body)['q0']['result'].first

    assert_equal ['Standard'], res['type']
    assert_equal 'ccls.1.2', res['name']
  end

  test 'POST /refine/reconcile for ResourceType' do
    [ :lesson, :quiz ].each {|key| resource_types(key).save }
    sleep 1

    post '/refine/reconcile', queries: query_for('ResourceType', 'les.')
    assert_equal 201, last_response.status
    res = JSON.parse(last_response.body)['q0']['result'].first

    assert_equal ['ResourceType'], res['type']
    assert_equal 'lesson', res['name']
  end
end
