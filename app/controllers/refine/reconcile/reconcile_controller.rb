# require 'json'

class Refine::Reconcile::ReconcileController < ActionController::Base
  # skip_before_action :verify_authenticity_token

  #
  # There's a single action which replies to OpenRefine requests.
  #
  def index
    if wants_service_metadata?
      render json: service_metadata, callback: params[:callback]
    elsif wants_query?
      set_queries
      render json: reconcile, callback: params[:callback]
    end
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

    # @queries.each do |k, query|
    #   results[k] = {
    #     result: model.reconcile(query[:query], limit: query[:limit])
    #   }
    # end

    results
  end

  #
  # Parse the OpenRefine query payload.
  #
  def set_queries
    @queries = params[:queries]

    unless @queries.is_a? Hash
      @queries = JSON.parse(@queries, symbolize_names: true)
    end
  end

  #
  # Check whether this is a service metadata request.
  #
  def wants_service_metadata?
    params[:queries].blank?
  end

  #
  # Check whether this is a query request.
  #
  def wants_query?
    params[:queries].present?
  end

  #
  # Model name derived from controller name.
  #
  def model_name
    controller_name.classify
  end

  #
  # Model class derived from controller name.
  #
  def model
    model_name.constantize
  end
end
