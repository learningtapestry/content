module Search
  module SimpleSearch

    def self.included(base)
      base.class_eval do
        include Client
        include Dsl

        attr_accessor :index

        # get the Model from the Search class name, i.e:
        # Search::LanuagesSearch => Language
        def self.model
          @model ||= self.name.demodulize.singularize.gsub('Search', '').constantize
        end

        def model
          self.class.model
        end

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
end
