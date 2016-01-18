module Search
  class Results
    attr_reader :results, :sources, :total_hits

    def initialize(results)
      @results = results
      @total_hits = results['hits']['total']
    end

    def ids
      @ids ||= results['hits']['hits'].map { |h| h['_id'] }
    end

    def records
      Document.find(ids)
    end

    def sources
      results['hits']['hits'].map { |h| h['_source'] }
    end

    def facets
      top_hits_paths = {
        'grades' => 'name',
        'identities' => 'name',
        'languages' => 'name',
        'resource_types' => 'name',
        'standards' => 'name',
        'subjects' => 'name'
      }
      aggs = {}
      results['aggregations'].keys.each do |k|
        aggs[k] = results['aggregations'][k][k]['buckets'].map do |bucket|
          {
            id: bucket['key'],
            total: bucket['doc_count'],
            name: bucket['top_hits']['hits']['hits'][0]['_source'][top_hits_paths[k]]
          }
        end
      end
      aggs
    end

    def display
      d = { documents: sources }
      d[:facets] = facets if results['aggregations'].present?
      d
    end
  end
end
