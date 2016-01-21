module Refine::Reconcile::Helpers
  extend Grape::API::Helpers

  #
  # resouce model name
  def model_name
    model.name
  end

  #
  # Service metadata requests inform Refine about this endpoint.
  def service_metadata
    {
      name: "LT :: #{model_name} Reconciliation"
    }
  end

  #
  # Reconciliation queries do the actual reconciliation work.
  def reconcile(queries)
    Hash[queries.map { |k, query| [ k, {result: []} ] }] # result: model.reconcile(query[:query], limit: query[:limit])
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
end
