module Search
  module Indexes

    class IdentityIndex < Index
      def mappings
        {
          identity: {
            properties: {
              id: {type: 'string', index: 'not_analyzed'},
              name: {
                type: 'multi_field',
                fields: {
                  name:    {type: 'string', index: 'not_analyzed'},
                  full:    {type: 'string', analyzer: 'full_str'},
                  partial: {type: 'string', analyzer: 'partial_str'}
                }
              }
            }
          }
        }
      end

      def serialize(identity)
        IdentitySerializer.new(identity).as_json
      end
    end

  end
end
