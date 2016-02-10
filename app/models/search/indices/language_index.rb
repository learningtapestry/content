module Search
  module Indices

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
    end

  end
end
