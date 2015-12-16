require 'active_support/concern'

module HasValueField
  extend ActiveSupport::Concern

  included do
    def self.default_value_method(*vals)
      vals.map(&:to_s).each do |val|
        define_singleton_method(val) do
          find_by(value: val)
        end
      end
    end

    def self.string_to_value(str)
      str = str.to_s
      str.strip.gsub(/\s+/,'_').downcase
    end
  end
end
