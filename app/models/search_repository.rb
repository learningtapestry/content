require 'elasticsearch'
require 'elasticsearch/dsl'

class SearchRepository
  attr_reader :repository

  def initialize(repository:)
    @repository = repository
  end

  # DSL

  class DSL
    include Elasticsearch::DSL
  end

  class Results
    attr_accessor :total_count, :results
  end

  # Client

  def self.client
    @client ||= Elasticsearch::Client.new(url: ENV['ELASTICSEARCH_URL'], log: true)
  end

  def self.klass(klass = nil)
    @klass = klass unless klass.nil? ; @klass
  end

  def client
    self.class.client
  end

  def klass
    self.class.klass
  end

  def klass_name
    @klass_name ||= klass.name.downcase
  end

  # Indexing

  def index_name
    klass_suffix      = "#{klass_name.pluralize}"
    env_suffix        = "__#{Rails.env}" unless Rails.env.production?
    repository_suffix = "__#{repository.id}"

    "#{klass_suffix}#{repository_suffix}#{env_suffix}"
  end

  def create_index!
    unless index_exists?
      client.indices.create(
        index: index_name,
        body: {
          settings: settings,
          mappings: mappings
        }
      )
    end
  end

  def delete_index!
    client.indices.delete(index: index_name)
  end

  def update_index_settings!(new_settings)
    client.indices.close(index: index_name)
    client.indices.put_settings(index: index_name, body: new_settings)
    client.indices.open(index: index_name)
  end

  def index_exists?
    client.indices.exists(index: target_index) rescue false
  end

  def mappings
    {}
  end

  def settings
    {}
  end

  # Storage

  def save(document)
    serialized = document.as_json(root: false)

    res = client.index(
      id:    document.id,
      body:  serialized,
      index: index_name,
      type:  "#{klass_name}"
    )

    document.update_column(:indexed_at, Time.now)

    res
  end

  def delete(document)
    client.delete(
      id:    document.id,
      index: index_name,
      type:  "#{klass_name}"
    )
  end

  def dsl(&blk)
    builder = self.class::DSL.new
    builder.search(&blk)
  end
end
