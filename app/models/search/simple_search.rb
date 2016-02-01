require 'active_support/concern'

module Search
  module SimpleSearch
    extend ActiveSupport::Concern

    included do
      include Client
      include Dsl

      attr_accessor :index

      def index_name
        model.new.search_index.index_name
      end

      def type_name
        model.new.search_index.type_name
      end

      def parse_results(res)
        ::Search::Results.new res, model
      end

      def search(options = {})
        parse_results client.search(index: index_name, body: query(options), type: type_name)
      end
    end
  end
end
