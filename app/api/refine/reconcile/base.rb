require 'active_support/concern'

#
# Base module to be included on every reconcile service
module Refine::Reconcile::Base
  extend ActiveSupport::Concern

  included do
    # enable jsonp support
    use Rack::JSONP

    # by default use json
    format :json
    formatter :json, Grape::Formatter::ActiveModelSerializers

    # always include base helper
    helpers Refine::Reconcile::Helpers

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
end
