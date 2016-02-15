module Search
  module Client

    def self.included(base)
      base.class_eval do
        def self.client
          @client ||= begin
            url = ENV.fetch('ELASTICSEARCH_URL', 'http://localhost:9200')
            log = Rails.env.test? ? false : Rails.logger

            Elasticsearch::Client.new(url: url, log: log)
          end
        end

        def client
          self.class.client
        end
      end
    end

  end
end
