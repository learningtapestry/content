require 'securerandom'
require 'test_helper'

module Search
  class ClientTest < ActiveSupport::TestCase
    class IncludesSearchClient
      include Client
    end

    test '#client, .client return an ElasticSearch client' do
      assert_kind_of Elasticsearch::Transport::Client, IncludesSearchClient.client
      assert_kind_of Elasticsearch::Transport::Client, IncludesSearchClient.new.client
    end
  end
end
