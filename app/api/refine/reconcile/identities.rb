class Refine::Reconcile::Identities < Grape::API
  include Refine::Reconcile::Base

  helpers do
    def model; Identity end

    def reconcile_query(query)
      res = Search::IdentitySearch.new.search(q: query[:query], limit: query[:limit])
      res.hits.map { |h|
        {
          id: h._id,
          name: h._source.name,
          type: ['Identity'],
          score: h._score,
          match: h._score > 0.2,
        }
      }
    end
  end
end
