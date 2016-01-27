module Search
  class GradeSearch
    include Client
    include Dsl

    attr_accessor :index

    def index_name
      Grade.new.search_index.index_name
    end

    def search(options = {})
      limit = options[:limit] || 100
      page = options[:page] || 1
      term = options[:q]

      definition = dsl do
        size limit
        from (page - 1) * limit

        query do
          filtered do
            query do
              bool do
                should { match 'name.full'    => { query: term, operator: "and", type: 'phrase', boost: 3 } }
                should { match 'name.partial' => { query: term, operator: "and", boost: 1 } }
              end
            end
          end
        end
      end

      parse_results client.search(index: index_name, body: definition, type: 'grade')
    end

    def parse_results(res)
      ::Search::Results.new res, Grade
    end

  end
end
