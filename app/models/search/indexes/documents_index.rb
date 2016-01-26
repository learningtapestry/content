module Search
  module Indexes

    class DocumentsIndex < Index
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

      def serialize(document)
        DocumentIndexedSerializer.new(document).as_json
      end

      def after_save(document, response)
        document.update_column(:indexed_at, Time.now)
        true
      end

      def after_delete(document, response)
        document.update_column(:indexed_at, nil) if Document.exists?(document.id)
        document
      end

      def after_bulk_index(ids)
        Document.where(id: ids).update_all(
          indexed_at: Document.new._current_time_from_proper_timezone
        )
      end
    end

  end
end
