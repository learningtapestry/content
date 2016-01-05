module Search
  class Search
    include Client
    include Dsl

    attr_accessor :indices

    class Results
      attr_reader :results, :hits

      def initialize(results)
        @results = results
        @hits = results['hits']['hits']
      end

      def transform
        Document.find(@hits.map { |h| h['_id'] })
      end
    end

    def initialize(*indices)
      self.indices = indices
    end

    def search(options = {})
      q = options[:q]

      definition = dsl do
        if q.present?
          query do
            bool do
              should { match title: { query: q, operator: 'and', boost: 2 } }
              should { match description: { query: q, operator: 'and' } }
            end

          end
        end

        if options[:only].is_a? Array
          fields options[:only]
        end
      end

      Search::Results.new(client.search(
        index: index_names,
        body: definition,
        type: 'document'
      ))
    end

    def index_names
      indices.map(&:index_name).join(',')
    end
  end
end
