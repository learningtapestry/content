class Refine::Reconcile::Grades < Grape::API
  include Refine::Reconcile::Base

  helpers do
    # Model class derived from controller name.
    def model
      Grade
    end
  end

  params do
    requires :callback, type: String
  end
  get '/' do
    if wants_service_metadata?
      service_metadata
    else
      error!("400 Bad Request", 400)
    end
  end

  post '/' do
    if wants_query?
      set_queries
      reconcile
    else
      error!("400 Bad Request", 400)
    end
  end

end
