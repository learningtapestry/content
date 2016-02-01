class Refine::Reconcile::Languages < Grape::API
  include Refine::Reconcile::Base

  helpers do
    def model; Language end

    def reconcile_query(query)
      res = Search::LanguageSearch.new.search(q: query[:query], limit: query[:limit])
      res.hits.map { |h|
        {
          id: h._id,
          name: h._source.name,
          type: ['Language'],
          score: h._score,
          match: h._score > 0.2,
        }
      }
    end
  end
end
