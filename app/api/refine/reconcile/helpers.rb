module Refine::Reconcile::Helpers
  extend Grape::API::Helpers

  def model_name
    model.name
  end

  #
  # Service metadata requests inform Refine about this endpoint.
  #
  def service_metadata
    {
      name: "LT :: #{model_name} Reconciliation"
    }
  end

  #
  # Reconciliation queries do the actual reconciliation work.
  #
  def reconcile
    results = {}
    @queries.each do |k, query|
      results[k] = {
        result: [], # model.reconcile(query[:query], limit: query[:limit])
      }
    end

    results
  end

  # Parse the OpenRefine query payload.
  def set_queries
    @queries = params[:queries]
    @queries = JSON.parse(@queries, symbolize_names: true) unless @queries.is_a? Hash
  end

  # Check whether this is a service metadata request.
  def wants_service_metadata?
    params[:queries].blank?
  end

  # Check whether this is a query request.
  def wants_query?
    params[:queries].present?
  end

end
