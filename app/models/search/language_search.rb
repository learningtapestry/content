module Search
  class LanguageSearch
    include Client
    include Dsl

    attr_accessor :index

    def index_name
      Language.new.search_index.index_name
    end

    def search(options = {})
      limit = options[:limit] || 100
      page = options[:page] || 1
      term = options[:q]

      definition = dsl do
        size limit
        from (page - 1) * limit

        query do
          bool do
            should { match 'name.full'         => { query: term, operator: "and", type: 'phrase', boost: 3 } }
            should { match 'name.partial'      => { query: term, operator: "and", boost: 1 } }
            should { match 'full_name.full'    => { query: term, operator: "and", type: 'phrase', boost: 5 } }
            should { match 'full_name.partial' => { query: term, operator: "and", boost: 1 } }
          end
        end
      end

      parse_results client.search(index: index_name, body: definition, type: 'language')
    end

    def parse_results(res)
      ::Search::Results.new res, Language
    end

  end
end
