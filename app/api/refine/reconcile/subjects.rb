class Refine::Reconcile::Subjects < Grape::API
  include Refine::Reconcile::Base

  helpers do
    def model; Subject end

    def reconcile_query(query)
      res = Search::SubjectSearch.new.search(q: query[:query], limit: query[:limit])
      res.hits.map { |h|
        {
          id: h._id,
          name: h._source.name,
          type: ['Subject'],
          score: h._score,
          match: h._score > 0.2,
        }
      }
    end
  end
end
