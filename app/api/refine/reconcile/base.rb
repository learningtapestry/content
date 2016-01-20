require 'active_support/concern'

module Refine::Reconcile::Base
  extend ActiveSupport::Concern

  included do
    # by default use json
    format :json
    formatter :json, Grape::Formatter::ActiveModelSerializers

    # add JSONP formatter
    content_type :jsonp, 'text/javascript; charset=utf-8'
    formatter :jsonp, ->(object, env) { "/**/#{object[:callback]}(#{object[:data].to_json})\n" }

    # always include base helper
    helpers Refine::Reconcile::Helpers
  end
end
