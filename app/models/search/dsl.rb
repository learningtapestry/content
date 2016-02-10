module Search
  module Dsl

    class DSL
      include Elasticsearch::DSL
    end

    class Results
      attr_accessor :total_count, :results
    end

    def self.included(base)
      base.class_eval do
        def dsl(&blk)
          builder = self.class::DSL.new
          builder.search(&blk)
        end
      end
    end

  end
end
