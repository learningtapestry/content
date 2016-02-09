class Refine::Reconcile < Grape::API
  # before do
  #   error!("401 Unauthorized", 401) unless authorized?
  # end

  helpers do

    # Types which our API can reconcile.
    def services
      [ 'Grade', 'Language', 'Identity', 'ResourceType', 'Subject', 'Standard' ]
    end

    # Service metadata requests inform Refine about this endpoint.
    # The defaultTypes tell which types we can resolve.
    def service_metadata
      {
        name: "LT :: Reconciliation",
        defaultTypes: services.map { |type| {id: type, name: type} }
      }
    end

    # Reconciliation for multiple queries.
    def reconcile_multi(queries)
      Hash[queries.map { |k, query| [ k, {result: reconcile_query(query)} ] }]
    end

    # Reconcile each single query given a 'type'
    def reconcile_query(query)
      if query[:type].present?
        res = search(query)
        parse_results(res, query)
      else
        []
      end
    end

    # Parse the OpenRefine query payload.
    def parse_queries
      queries = params[:queries]
      queries = JSON.parse(queries, symbolize_names: true) unless queries.is_a? Hash
      queries
    end

    # Check whether this is a service metadata request.
    def is_service_metadata?
      params[:queries].blank?
    end

    # Check whether this is a query request.
    def is_query?
      params[:queries].present?
    end

    # Search for the most similar entries on our index
    # We use the type to define the proper search , i.e: type='Grade' => Search::GradeSearch
    def search(query)
      search_class = "Search::#{query[:type]}Search".constantize
      search_class.new.search(q: query[:query], limit: query[:limit])
    end

    # OpenRefine expectd results properly formatted
    # read more here -> https://github.com/OpenRefine/OpenRefine/wiki/Reconciliation-Service-API#query-response
    def parse_results(res, query)
      type = query[:type]
      res.hits.map { |h|
        {
          id: h._id,
          name: h._source.name,
          type: [type],  # must be an array
          score: h._score,
          match: h._score >= match_threshold(type),
        }
      }
    end

    # define type specific thresholds for matching scores
    def match_threshold(type)
      {'Grade' => 0.7, 'Language' => 0.2}.fetch(type, 0.5)
    end
  end

  # enable jsonp support
  use Rack::JSONP

  # by default use json
  format :json
  formatter :json, Grape::Formatter::ActiveModelSerializers

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
    reconcile_multi parse_queries
  end
end
