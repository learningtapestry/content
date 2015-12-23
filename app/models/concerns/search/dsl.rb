require 'active_support/concern'

module Search
  module Dsl
    extend ActiveSupport::Concern

    included do
      class DSL
        include Elasticsearch::DSL
      end

      class Results
        attr_accessor :total_count, :results
      end
      
      def dsl(&blk)
        builder = self.class::DSL.new
        builder.search(&blk)
      end
    end
  end
end
