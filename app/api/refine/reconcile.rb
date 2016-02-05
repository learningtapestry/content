class Refine::Reconcile < Grape::API
  # before do
  #   error!("401 Unauthorized", 401) unless authorized?
  # end

  helpers do
    def services
      ['Grade', 'Language', 'Identity', 'ResourceType', 'Subject', 'Standard']
    end

    #
    # Service metadata requests inform Refine about this endpoint.
    def service_metadata
      {
        name: "LT :: Reconciliation",
        defaultTypes: services.map { |type| {id: type, name: type} }
      }
    end

    #
    # Reconciliation multiple queries.
    def reconcile_multi(queries)
      Hash[queries.map { |k, query| [ k, {result: reconcile_query(query)} ] }]
    end

    #
    # Reconcile query should be *overridden* and contain the actual reconciliation logic
    def reconcile_query(query)
      if query[:type].present?
        res = search query
        parse_results(res, query)
      else
        []
      end
    end

    #
    # Parse the OpenRefine query payload.
    def parse_queries
      queries = params[:queries]
      queries = JSON.parse(queries, symbolize_names: true) unless queries.is_a? Hash
      queries
    end

    #
    # Check whether this is a service metadata request.
    def is_service_metadata?
      params[:queries].blank?
    end

    #
    # Check whether this is a query request.
    def is_query?
      params[:queries].present?
    end

    def search(query)
      search_class = "Search::#{query[:type]}Search".constantize
      search_class.new.search(q: query[:query], limit: query[:limit])
    end

    def parse_results(res, query)
      type = query[:type]
      res.hits.map { |h|
        {
          id: h._id,
          name: h._source.name,
          type: [type],
          score: h._score,
          match: h._score >= match_threshold(type),
        }
      }
    end

    def match_threshold(type)
      {'Grade' => 1, 'Language' => 0.2}.fetch(type, 0.7)
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
