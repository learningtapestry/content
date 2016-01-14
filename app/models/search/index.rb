require 'elasticsearch'
require 'elasticsearch/dsl'

module Search
  class Index
    include Client

    attr_reader :repository

    def initialize(repository:)
      @repository = repository
    end

    # Indexing

    def index_name
      doc_suffix        = "documents"
      env_suffix        = "__#{Rails.env}" unless Rails.env.production?
      repository_suffix = "__#{repository.id}"

      "#{doc_suffix}#{repository_suffix}#{env_suffix}"
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
        type: 'document',
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
      {
        document: {
          properties: {
            grades: {
              type: :nested
            },
            identities: {
              type: :nested
            },
            languages: {
              type: :nested
            },
            resource_types: {
              type: :nested
            },
            standards: {
              type: :nested
            },
            subjects: {
              type: :nested
            }
          }
        }
      }
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
        type:  'document'
      )

      if res['created']
        document.update_column(:indexed_at, Time.now)
        true
      end
    end

    def delete(document)
      res = client.delete(
        id:    document.id,
        index: index_name,
        type:  'document'
      )

      if res['found']
        document.update_column(:indexed_at, nil) if Document.exists?(document.id)
        document
      end
    end
  end
end
