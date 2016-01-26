module Search
  module Indexes

    class GradesIndex < Index
      def mappings
        {
          grade: {
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

      def serialize(grade)
        GradeSerializer.new(grade).as_json
      end
    end

  end
end
