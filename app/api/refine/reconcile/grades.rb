class Refine::Reconcile::Grades < Grape::API
  include Refine::Reconcile::Base

  helpers do
    def model; Grade end

    def reconcile_query(query)
      # model.reconcile **query
      res = Search::GradeSearch.new.search(q: query[:query], limit: query[:limit])
      res.hits.map { |h|
        {
          id: h._id,
          name: h._source.name,
          type: ['Grade'],
          score: h._score,
          match: h._score > 1.0,
        }
      }
    end
  end
end
