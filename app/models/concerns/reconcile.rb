require 'active_support/concern'

module Reconcile
  extend ActiveSupport::Concern

  class Reconciler
    def initialize(klass, finder:, creator:)
      @klass = klass
      @finder = finder
      @creator = creator
    end

    def reconcile(repository, value)
      mappables = repository
        .value_mappings
        .where(mappable_type: @klass)
        .where(value: normalize(value))
        .order(rank: :desc)
        .map(&:mappable)

      if mappables.empty?
        unmapped = @klass.instance_exec(repository, value, &@finder)

        if unmapped.any?
          unmapped.each do |u|
            repository.value_mappings.create!(
              mappable: u,
              value: normalize(value),
              rank: 1
            )
          end
          mappables = unmapped
        else
          new_mappable = @klass.instance_exec(repository, value, &@creator)
          repository.value_mappings.create!(
            mappable: new_mappable,
            value: normalize(value),
            rank: 1
          )
          mappables = [new_mappable]
        end
      end

      mappables
    end

    def normalize(value)
      value = value.to_s
      value.strip.gsub(/\s+/,'_').downcase
    end
  end

  included do
    def self.reconcile_by(field)
      if field.respond_to? :call
        @reconcile_by = field
      else
        @reconcile_by = ->(value) { where(field => value) }
      end
    end

    def self.reconcile_create(creator)
      @reconcile_create = creator
    end

    def self.reconcile(repo, value)
      reconciler = Reconciler.new(self, finder: @reconcile_by, creator: @reconcile_create)
      reconciler.reconcile(repo, value)
    end
  end
end
