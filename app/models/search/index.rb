require 'elasticsearch'
require 'elasticsearch/dsl'

# Base index class
module Search
  class Index
    include Client

    attr_reader :repository

    # for `Document`, we split one index per repository
    # but other types might not be separated (like grades)
    def initialize(repository: nil)
      @repository = repository
    end

    # =====================
    # Indexing

    # infer type_name from class.
    #
    # e.g:
    #    Search::Indexes::GradesIndex => 'grade'
    def type_name
      self.class.name.demodulize.gsub('Index', '').underscore.singularize
    end

    # index_name follows the pattern: '<type_name>__<repo_id>__<env>'
    #
    # e.g.:
    #   'documents__123__development'
    #   'grades__staging'
    def index_name
      @index_name ||= begin
        parts = [type_name.pluralize]
        parts << repository.id if repository
        parts << Rails.env unless Rails.env.production?
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

    # Define a specific mapping schema for this type
    # The mappings are defined as a serializable Hash.
    #
    # e.g:
    #    {
    #      <type_name>: {  # top key should be the type_name, i.e: GradesIndex => 'grade'
    #        properties: {
    #          # define you document properties mappings here
    #        }
    #      }
    #    }
    #
    #  For more info on mappings: https://www.elastic.co/guide/en/elasticsearch/reference/2.1/mapping.html
    def mappings
      raise NotImplementedError 'must define a mapping'
    end

    # Filter and Analyzer settings.
    # Can be Overrided to define any additional specific setting
    #
    # partial_str: is a simple N-Gram analyzer for doing fuzzy partial full-text search
    # full_str: string analyzer, slightly improved from standard
    #
    # For more info: https://www.elastic.co/guide/en/elasticsearch/reference/2.1/analysis-custom-analyzer.html
    def settings
      {
        index: {
          analysis: {
            filter: {
              str_ngrams: {type: "nGram", min_gram: 2, max_gram: 10},
              stop_en:    {type: "stop", stopwords: "_english_"},
            },
            analyzer: {
              full_str: {
                filter: ["standard", "lowercase", "stop_en", "asciifolding"],
                type: "custom",
                tokenizer: "standard",
              },
              partial_str: {
                filter: ["standard", "lowercase", "stop_en", "asciifolding", "str_ngrams"],
                type: "custom",
                tokenizer: "standard",
              }
            }
          }
        }
      }
    end

    # Convert a document object to json-serializable Hash
    #
    # Can be *Overridden* for the specific type (see `DocumentsIndex#serialize` for an Example)
    def serialize(document)
      begin
        serializer.new(document).as_json
      rescue
        document.as_json
      end
    end

    # Try to find a corresponding `AM::Serializer` given the associated model name.
    # I.e:
    #   MyModelIndex => MyModelSerializer
    def self.serializer
      @serializer ||= begin
        model_name = self.name.demodulize.gsub('Index', '')
        "#{model_name}Serializer".constantize
      end
    end

    def serializer
      self.class.serializer
    end

    # =====================
    # Storage

    def save(document)
      create_index!

      serialized = serialize(document)
      res = client.index(
        id:    document.id,
        body:  serialized,
        index: index_name,
        type:  type_name
      )

      saved = !!res['created']
      after_save(document, res) if saved

      saved
    end
    alias_method :index, :save

    # Overridable callback.
    # called after the document is succesfully saved.
    #
    # params:
    #   :document:  is the original object
    #   :res:       is the ES response
    def after_save(document, res)
      # override-me
    end


    def delete(document)
      res = client.delete(
        id:    document.id,
        index: index_name,
        type:  type_name
      )

      deleted = !!res['found']
      after_delete(document, res) if deleted

      deleted
    end

    # Overridable callback.
    # called after the document is succesfully deleted.
    #
    # params:
    #   :document:  is the original object
    #   :res:       is the ES response
    def after_delete(document, res)
      # override-me
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
              data: serialize(doc)
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

    def after_bulk_index(updated_ids)
      # override-me
    end

  end
end
