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
  end
end
