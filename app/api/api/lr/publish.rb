class API::LR::Publish < Grape::API
  helpers do
    def error(message)
      response = {
        OK: false,
        error: message
      }

      error!(response, 500)
    end
  end

  post '/' do
    error("Missing field 'documents' in post body") unless params.key?('documents')
    error('List of documents is empty') if params['documents'].empty?

    results = params['documents'].map do |document|
      envelope = Envelope.create_or_update(document)
      result = {
        doc_ID: envelope.doc_id,
        OK: envelope.persisted?
      }
      result[:error] = envelope.errors.full_messages.join('. ') unless envelope.persisted?
      result
    end

    result = {
      OK: results.all? { |r| r[:OK] },
      document_results: results
    }

    result[:OK] ? result : error!(result, 500)
  end
end
