require 'active_support/concern'

module Reconcile
  extend ActiveSupport::Concern

  class Reconciler
    def initialize(klass, finder:, creator:)
      @klass = klass
      @finder = finder
      @creator = creator
    end

    def reconcile(context)
      repo       = context[:repository]
      value      = context[:value]
      normalized = normalize(value)

      reconciled = repo
        .value_mappings
        .where(mappable_type: @klass)
        .where(value: normalized)
        .order(rank: :desc)
        .map(&:mappable)

      if reconciled.empty?
        found = @klass.instance_exec(context, &@finder)

        if found.any?
          found.each do |f|
            repo.value_mappings.create!(
              mappable: f,
              value: normalized,
              rank: 1
            )
          end
          reconciled = found
        else
          created = @klass.instance_exec(context, &@creator)
          repo.value_mappings.create!(
            mappable: created,
            value: normalized,
            rank: 1
          )
          reconciled = [created]
        end
      end

      reconciled
    end

    def normalize(value)
      value = value.to_s
      value.strip.gsub(/\s+/,'_').downcase
    end
  end

  included do
    def self.reconcile_by(field_or_callable)
      if field_or_callable.respond_to? :call
        @reconcile_by = field_or_callable
      else
        @reconcile_by = ->(context) { where(field_or_callable => context[:value]) }
      end
    end

    def self.reconcile_create(creator)
      @reconcile_create = creator
    end

    def self.reconcile(context)
      unless context[:repository].present?
        raise ArgumentError.new('Context requires a repository')
      end
        
      unless context[:value].present?
        raise ArgumentError.new('Context requires a value')
      end

      reconciler = Reconciler.new(self, finder: @reconcile_by, creator: @reconcile_create)
      reconciler.reconcile(context)
    end
  end
end
