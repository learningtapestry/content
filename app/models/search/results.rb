module Search
  class Results
    attr_reader :results, :sources, :total_hits, :model, :hits

    def initialize(results, model=nil)
      @results = results
      @total_hits = results['hits']['total']
      @hits = results['hits']['hits'].map { |hit| Hashie::Mash.new **hit.symbolize_keys }
      @model = model
    end

    def result_key
      model.name.underscore.pluralize.to_sym
    end

    def ids
      @ids ||= hits.map { |h| h._id }
    end

    def records
      model.find(ids)
    end

    def sources
      hits.map { |h| h['_source'] }
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
      d = { result_key => sources }
      d[:facets] = facets if results['aggregations'].present?
      d
    end
  end
end
