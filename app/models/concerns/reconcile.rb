require 'active_support/concern'

module Reconcile
  extend ActiveSupport::Concern

  class Reconciler
    def initialize(klass, finder:, creator:, normalizer:)
      @klass = klass
      @finder = finder
      @creator = creator
      @normalizer = normalizer
    end

    def reconcile(context)
      repo       = context[:repository]
      normalized = @klass.instance_exec(context, &@normalizer)

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
  end

  included do
    def self.reconcile_by(field_or_callable)
      @reconcile_by = field_or_callable.respond_to?(:call) ? field_or_callable :
        ->(context) { where(field_or_callable => context[:value]) }
    end

    def self.reconcile_create(creator)
      @reconcile_create = creator
    end

    def self.reconcile_normalize(normalizer_or_callable)
      if normalizer_or_callable.respond_to?(:call)
        @reconcile_normalize = normalizer_or_callable
      elsif normalizer_or_callable == :default
        @reconcile_normalize = ->(context) { context[:value].to_s.strip.gsub(/\s+/,'_').downcase }
      elsif normalizer_or_callable == :skip
        @reconcile_normalize = ->(context) { context[:value].to_s }
      end
    end

    def self.reconcile(context)
      unless context[:repository].present?
        raise ArgumentError.new('Context requires a repository')
      end
        
      unless context[:value].present?
        raise ArgumentError.new('Context requires a value')
      end

      unless @reconcile_by.present? 
        raise ArgumentError.new('Reconcile requires a reconcile_by finder')
      end

      unless @reconcile_create.present? 
        raise ArgumentError.new('Reconcile requires a reconcile_create creator')
      end

      unless @reconcile_normalize.present? 
        raise ArgumentError.new('Reconcile requires a reconcile_normalize normalizer')
      end

      reconciler = Reconciler.new(self,
        finder: @reconcile_by,
        creator: @reconcile_create,
        normalizer: @reconcile_normalize
      )

      reconciler.reconcile(context)
    end
  end
end
