class Refine::Reconcile::Grades < Grape::API
  include Refine::Reconcile::Base

  helpers do
    # Model class derived from controller name.
    def model
      Grade
    end
  end

  format :jsonp
  params do
    requires :callback, type: String
  end
  get '/' do
    header 'X-Xss-Protection', '1; mode=block'
    header 'X-Frame-Options', 'SAMEORIGIN'
    header 'X-Content-Type-Options', 'nosniff'
    if wants_service_metadata?
      { data: service_metadata, callback: params[:callback] }
    # elsif wants_query?
    #   set_queries
    #   render json: reconcile, callback: params[:callback]
    end
  end

end
