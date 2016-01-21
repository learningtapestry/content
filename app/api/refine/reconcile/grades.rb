class Refine::Reconcile::Grades < Grape::API
  include Refine::Reconcile::Base

  helpers do
    def model; Grade end
  end

  params do
    requires :callback, type: String
  end
  get '/' do
    error!("400 Bad Request", 400) unless is_service_metadata?
    service_metadata
  end

  params do
    requires :queries, type: String
  end
  post '/' do
    error!("400 Bad Request", 400) unless is_query?
    reconcile parse_queries
  end
end
