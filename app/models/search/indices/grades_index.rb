module Search
  module Indices

    class GradesIndex < Index
      def settings
        {
          index: {
            analysis: {
              filter: {
                # Grades needs smaller 'grams' (starting from 1) to indentify the numbers at the end
                str_ngrams: {type: "nGram", min_gram: 1, max_gram: 6},
              },
              analyzer: {
                full_str: {
                  filter: ["lowercase", "asciifolding"],
                  type: "custom",
                  tokenizer: "standard",
                },
                partial_str: {
                  filter: ["lowercase", "asciifolding", "str_ngrams"],
                  type: "custom",
                  tokenizer: "standard",
                }
              }
            }
          }
        }
      end

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
    end

  end
end
