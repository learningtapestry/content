module Search
  class Search
    include Client
    include Dsl

    attr_accessor :indices

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

    def initialize(*indices)
      self.indices = indices
    end

    def search(options = {})
      limit = options[:limit]
      page = options[:page]

      filter_paths = {
        grade_id: ['grades', 'id'],
        identity_id: ['identities', 'id'],
        language_id: ['languages', 'id'],
        resource_type_id: ['resource_types', 'id'],
        standard_id: ['standards', 'id'],
        subject_id: ['subjects', 'id']
      }

      query_paths = {
        grade_name: ['grades', 'name'],
        identity_name: ['identities', 'name'],
        language_name: ['languages', 'name'],
        resource_type_name: ['resource_types', 'name'],
        standard_name: ['standards', 'name'],
        subject_name: ['subjects', 'name']
      }

      filters = filter_paths.keys.select { |f| options[f].present? }
      queries = query_paths.keys.select { |q| options[q].present? }

      definition = dsl do
        size limit
        from (page - 1) * limit

        query do
          filtered do
            filter do
              bool do
                filters.each do |param_name|
                  path_name, field_name = filter_paths[param_name]
                  must do
                    nested do
                      path path_name
                      filter do
                        term "#{path_name}.#{field_name}" => options[param_name]
                      end
                    end
                  end
                end
              end
            end

            query do
              bool do
                if (q = options[:q]).present?
                  should do
                    bool do
                      should { match title: { query: q, operator: 'and', boost: 2 } }
                      should { match description: { query: q, operator: 'and' } }
                    end
                  end
                elsif (title = options[:title]).present?
                  should { match title: { query: title, operator: 'and' } }
                elsif (description = options[:description]).present?
                  should { match description: { query: description, operator: 'and' } }
                end

                queries.each do |param_name|
                  path_name, field_name = query_paths[param_name]
                  should do
                    nested do
                      path path_name
                      query do
                        match "#{path_name}.#{field_name}" => { query: options[param_name], operator: 'and' }
                      end
                    end
                  end
                end
              end
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
