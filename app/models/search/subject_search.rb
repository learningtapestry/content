module Search
  class SubjectSearch
    include SimpleSearch

    def query(options = {})
      limit = options[:limit] || 100
      page = options[:page] || 1
      term = options[:q]

      dsl do
        size limit
        from (page - 1) * limit

        query do
          bool do
            should { match 'name.full'    => { query: term, boost: 5, type: 'phrase' } }
            should { match 'name.partial' => { query: term, boost: 1 } }
          end
        end
      end
    end
  end
end
