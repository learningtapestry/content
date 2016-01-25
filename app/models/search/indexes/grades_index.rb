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
    end

  end
end
