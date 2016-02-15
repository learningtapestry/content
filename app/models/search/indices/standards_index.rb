module Search
  module Indices

    class StandardsIndex < Index
      def mappings
        {
          standard: {
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
              url: {type: 'string', index: 'not_analyzed'},
              definitions: {type: 'string'},
              description: {type: 'string'},
            }
          }
        }
      end
    end

  end
end
