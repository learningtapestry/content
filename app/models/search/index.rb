require 'elasticsearch'
require 'elasticsearch/dsl'

module Search
  class Index
    include Client

    attr_reader :repository

    def initialize(repository: nil)
      @repository = repository
    end

    # Indexing

    def type_name
      self.class.name.demodulize.gsub('Index', '').downcase.singularize
    end

    def index_name
      @index_name ||= begin
        parts = [type_name.pluralize]
        parts << Rails.env unless Rails.env.production?
        parts << repository.id if repository
        parts.join('__')
      end
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

    def reset_index!
      delete_index!
      create_index!
    end

    def update_index_mapping!(new_mappings)
      client.indices.put_mapping(
        index: index_name,
        type: type_name,
        body: new_mappings
      )
    end

    def update_index_settings!(new_settings)
      client.indices.close(index: index_name)
      client.indices.put_settings(index: index_name, body: new_settings)
      client.indices.open(index: index_name)
    end

    def index_exists?
      client.indices.exists(index: index_name) rescue false
    end

    def mappings
      raise NotImplementedError 'must define a mapping'
    end

    def settings
      {}
    end

    # Storage

    def save(document)
      create_index!

      serialized = document.as_indexed_json

      res = client.index(
        id:    document.id,
        body:  serialized,
        index: index_name,
        type:  type_name
      )

      after_save(document, res) if res['created']
    end

    def after_save(document, res)
      # overridable
    end

    alias_method :index, :save

    def delete(document)
      res = client.delete(
        id:    document.id,
        index: index_name,
        type:  type_name
      )

      after_delete(document, res) if res['found']
    end

    def after_delete(document, res)
      # overridable
    end

    def bulk_index(documents)
      create_index!

      res = client.bulk(
        body: documents.map { |doc|
          {
            index: {
              _id: doc.id,
              _index: index_name,
              _type: type_name,
              data: doc.as_indexed_json
            }
          }
        }
      )

      should_update_ids = res['items'].map do |item|
        status = item['index']['status'].to_i
        (status == 200 || status == 201) ? item['index']['_id']  : nil
      end.compact

      after_bulk_index(should_update_ids)
      should_update_ids
    end
  end
end
