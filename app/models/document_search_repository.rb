class DocumentSearchRepository < SearchRepository
  klass Document

  def search(options = {})
    page = options[:page] || 1
    limit = options[:limit] || 100
    q = options[:q]

    definition = dsl do
      size limit
      from (page - 1) * limit

      if q.present?
        query do
          bool do
            should { match title: { query: q, operator: 'and', boost: 2 } }
            should { match description: { query: q, operator: 'and' } }
          end
        end
      end
    end

    client_results = client.search(index: index_name, body: definition)
  end
end
