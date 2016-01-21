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
  end
end
