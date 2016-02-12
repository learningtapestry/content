require 'test_helper'

class API::LR::PublishTest < APITest
  test 'no `document` root property' do
    post '/api/lr/publish', {}
    assert_equal status, 500
    assert_equal last_json['OK'], false
    assert_equal last_json['error'], "Missing field 'documents' in post body"

    post '/api/lr/publish', { foo: 'bar' }
    assert_equal status, 500
    assert_equal last_json['OK'], false
    assert_equal last_json['error'], "Missing field 'documents' in post body"
  end

  test 'list of document root property' do
    post '/api/lr/publish', { documents: [] }
    assert_equal status, 500
    assert_equal last_json['OK'], false
    assert_equal last_json['error'], "List of documents is empty"
  end

  test 'required attributes validation' do
    payload_placement  = 'attached'
    resource_data_type = 'resource'
    resource_locator   = 'http://example.com'
    submitter          = 'Learning Tapestry'
    submitter_type     = 'anonymous'
    submission_tos     = 'http://www.learningregistry.org/tos'

    document1 = {}
    document2 = { active: true }
    document3 = document2.merge(payload_placement: payload_placement)
    document4 = document3.merge(resource_data_type: resource_data_type)
    document5 = document4.merge(resource_locator: resource_locator)
    document6 = document5.merge(identity: { submitter: submitter })
    document7 = document6.deep_merge(identity: { submitter_type: submitter_type })
    document8 = document7.merge(TOS: { submission_TOS: submission_tos })

    post '/api/lr/publish', { documents: [document1, document2, document3, document4, document5, document6, document7, document8] }
    assert_equal status, 500
    assert_equal last_json['OK'], false
    assert_nil   last_json['error']
    
    results = last_json['document_results']
    assert_equal results[0].key?('doc_ID'), true
    assert_equal results[0]['doc_ID'],      nil
    assert_equal results[0]['OK'],          false
    assert_equal results[0]['error'],       "Active can't be blank. Payload placement can't be blank. Resource data type can't be blank. Resource locator can't be blank. Submission tos can't be blank. Submitter can't be blank. Submitter type can't be blank"
    assert_equal results[1].key?('doc_ID'), true
    assert_equal results[1]['doc_ID'],      nil
    assert_equal results[1]['OK'],          false
    assert_equal results[1]['error'],       "Payload placement can't be blank. Resource data type can't be blank. Resource locator can't be blank. Submission tos can't be blank. Submitter can't be blank. Submitter type can't be blank"
    assert_equal results[2].key?('doc_ID'), true
    assert_equal results[2]['doc_ID'],      nil
    assert_equal results[2]['OK'],          false
    assert_equal results[2]['error'],       "Resource data type can't be blank. Resource locator can't be blank. Submission tos can't be blank. Submitter can't be blank. Submitter type can't be blank"
    assert_equal results[3].key?('doc_ID'), true
    assert_equal results[3]['doc_ID'],      nil
    assert_equal results[3]['OK'],          false
    assert_equal results[3]['error'],       "Resource locator can't be blank. Submission tos can't be blank. Submitter can't be blank. Submitter type can't be blank"
    assert_equal results[4].key?('doc_ID'), true
    assert_equal results[4]['doc_ID'],      nil
    assert_equal results[4]['OK'],          false
    assert_equal results[4]['error'],       "Submission tos can't be blank. Submitter can't be blank. Submitter type can't be blank"
    assert_equal results[5].key?('doc_ID'), true
    assert_equal results[5]['doc_ID'],      nil
    assert_equal results[5]['OK'],          false
    assert_equal results[5]['error'],       "Submission tos can't be blank. Submitter type can't be blank"
    assert_equal results[6].key?('doc_ID'), true
    assert_equal results[6]['doc_ID'],      nil
    assert_equal results[6]['OK'],          false
    assert_equal results[6]['error'],       "Submission tos can't be blank"

    assert_equal Envelope.count, 1
    envelope = Envelope.last
    assert_equal results[7]['doc_ID'],     envelope.doc_id
    assert_equal results[7]['OK'],         true
    assert_equal results[7].key?('error'), false
    assert_equal envelope.active,              true
    assert_equal envelope.doc_version,        '0.51.1'
    assert_equal envelope.doc_type,           'resource_data'
    assert_equal envelope.payload_placement,  payload_placement
    assert_equal envelope.resource_data_type, resource_data_type
    assert_equal envelope.resource_locator,   resource_locator
    assert_equal envelope.submitter,          submitter
    assert_equal envelope.submitter_type,     submitter_type
    assert_equal envelope.submission_tos,     submission_tos
  end

  test '`payload_placement` validation' do
    bad_value = 'wtf'
    assert_raise ArgumentError, "'#{bad_value}' is not a valid payload_placement" do
      post '/api/lr/publish', { documents: [{ payload_placement: bad_value }] }
    end

    %w(attached inline linked).each do |value|
      assert_nothing_raised do
        post '/api/lr/publish', { documents: [{ payload_placement: value }] }
      end
    end
  end

  test '`submitter_type` validation' do
    bad_value = 'wtf'
    assert_raise ArgumentError, "'#{bad_value}' is not a valid submitter_type" do
      post '/api/lr/publish', { documents: [{ identity: { submitter_type: bad_value } }] }
    end

    %w(agent anonymous user).each do |value|
      assert_nothing_raised do
        post '/api/lr/publish', { documents: [{ identity: { submitter_type: value } }] }
      end
    end
  end

  test '`payload_locator` validation' do
    post '/api/lr/publish', { documents: [{ payload_placement: 'attached' }] }
    assert_equal status, 500
    assert_not_includes last_json['document_results'].first['error'], "Payload locator can't be blank"

    post '/api/lr/publish', { documents: [{ payload_placement: 'inline' }] }
    assert_equal status, 500
    assert_not_includes last_json['document_results'].first['error'], "Payload locator can't be blank"

    post '/api/lr/publish', { documents: [{ payload_placement: 'linked' }] }
    assert_equal status, 500
    assert_includes last_json['document_results'].first['error'], "Payload locator can't be blank"

    post '/api/lr/publish', { documents: [{ payload_locator: 'http://example.com', payload_placement: 'linked' }] }
    assert_equal status, 500
    assert_not_includes last_json['document_results'].first['error'], "Payload locator can't be blank"
  end

  test '`resource_data` validation' do
    post '/api/lr/publish', { documents: [{ payload_placement: 'attached' }] }
    assert_equal status, 500
    assert_not_includes last_json['document_results'].first['error'], "Resource data can't be blank"

    post '/api/lr/publish', { documents: [{ payload_placement: 'linked' }] }
    assert_equal status, 500
    assert_not_includes last_json['document_results'].first['error'], "Resource data can't be blank"

    post '/api/lr/publish', { documents: [{ payload_placement: 'inline' }] }
    assert_equal status, 500
    assert_includes last_json['document_results'].first['error'], "Resource data can't be blank"

    post '/api/lr/publish', { documents: [{ payload_placement: 'inline', resource_data: 'How much wood would a woodchuck chuck?' }] }
    assert_not_includes last_json['document_results'].first['error'], "Resource data can't be blank"
  end

  test 'signature attributes validation' do
    post '/api/lr/publish', { documents: [{}] }
    assert_equal status, 500
    assert_not_includes last_json['document_results'].first['error'], "Signature can't be blank"
    assert_not_includes last_json['document_results'].first['error'], "Signature key location can't be blank"
    assert_not_includes last_json['document_results'].first['error'], "Signing method can't be blank"

    post '/api/lr/publish', { documents: [{ signature: { key_location: [] } }] }
    assert_equal status, 500
    assert_not_includes last_json['document_results'].first['error'], "Signature can't be blank"
    assert_not_includes last_json['document_results'].first['error'], "Signature key location can't be blank"
    assert_not_includes last_json['document_results'].first['error'], "Signing method can't be blank"

    post '/api/lr/publish', { documents: [{ signature: { signature: 'foo' } }] }
    assert_equal status, 500
    assert_includes last_json['document_results'].first['error'], "Signature key location can't be blank"
    assert_includes last_json['document_results'].first['error'], "Signing method can't be blank"

    post '/api/lr/publish', { documents: [{ signature: { key_location: ['foo'] } }] }
    assert_equal status, 500
    assert_includes last_json['document_results'].first['error'], "Signature can't be blank"
    assert_includes last_json['document_results'].first['error'], "Signing method can't be blank"

    post '/api/lr/publish', { documents: [{ signature: { signing_method: 'foo' } }] }
    assert_equal status, 500
    assert_includes last_json['document_results'].first['error'], "Signature can't be blank"
    assert_includes last_json['document_results'].first['error'], "Signature key location can't be blank"
  end

  test '`weight` validation' do
    post '/api/lr/publish', { documents: [{ weight: -101 }] }
    assert_equal status, 500
    assert_includes last_json['document_results'].first['error'], 'Weight must be greater than or equal to -100'

    post '/api/lr/publish', { documents: [{ weight: -100 }] }
    assert_equal status, 500
    assert_not_includes last_json['document_results'].first['error'], 'Weight'

    post '/api/lr/publish', { documents: [{ weight: 101 }] }
    assert_equal status, 500
    assert_includes last_json['document_results'].first['error'], 'Weight must be less than or equal to 100'

    post '/api/lr/publish', { documents: [{ weight: 100 }] }
    assert_equal status, 500
    assert_not_includes last_json['document_results'].first['error'], 'Weight'
  end
end
