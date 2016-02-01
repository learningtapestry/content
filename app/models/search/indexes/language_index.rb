module Search
  module Indexes

    class LanguageIndex < Index
      def mappings
        {
          language: {
            properties: {
              id: {type: 'string', index: 'not_analyzed'},
              name: {
                type: 'multi_field',
                fields: {
                  name:    {type: 'string', index: 'not_analyzed'},
                  full:    {type: 'string', analyzer: 'full_str'},
                  partial: {type: 'string', analyzer: 'partial_str'}
                }
              },
              full_name: {
                type: 'multi_field',
                fields: {
                  full_name: {type: 'string', index: 'not_analyzed'},
                  full:      {type: 'string', analyzer: 'full_str'},
                  partial:   {type: 'string', analyzer: 'partial_str'}

                }
              }
            }
          }
        }
      end

      def serialize(grade)
        LanguageSerializer.new(grade).as_json
      end
    end

  end
end
