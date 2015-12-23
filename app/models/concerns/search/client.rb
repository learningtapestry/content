require 'active_support/concern'

module Search
  module Client
    extend ActiveSupport::Concern
    
    included do
      def self.client
        @client ||= Elasticsearch::Client.new(url: ENV['ELASTICSEARCH_URL'], log: true)
      end

      def client
        self.class.client
      end
    end
  end
end
