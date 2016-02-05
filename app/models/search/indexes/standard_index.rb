module Search
  module Indexes

    class StandardIndex < Index
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
              url: {type: 'string', index: 'not_analyzed'}
            }
          }
        }
      end
    end

  end
end
