require 'active_support/concern'

module Refine::Reconcile::Base
  extend ActiveSupport::Concern

  included do
    use Rack::JSONP

    # by default use json
    format :json
    formatter :json, Grape::Formatter::ActiveModelSerializers

    # always include base helper
    helpers Refine::Reconcile::Helpers
  end
end
