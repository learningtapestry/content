require 'active_support/concern'

module Reconcile
  extend ActiveSupport::Concern

  class Reconciler
    def initialize(klass, find:, create:, normalize:)
      @klass = klass
      @find = find
      @create = create
      @normalize = normalize
    end

    def reconcile(context)
      repo       = context[:repository]
      normalized = @klass.instance_exec(context, &@normalize)

      value_mappings = repo.present? ? repo.value_mappings : ValueMapping
      reconciled = value_mappings
        .where(mappable_type: @klass)
        .where(value: normalized)
        .order(rank: :desc)
        .map(&:mappable)

      if reconciled.empty?
        found = @klass.instance_exec(context, &@find)

        if found.any?
          found.each do |f|
            value_mappings.create!(
              mappable: f,
              value: normalized,
              rank: 1
            )
          end
          reconciled = found
        else
          created = @klass.instance_exec(context, &@create)
          value_mappings.create!(
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
    def self.reconciles(find:, create:, normalize:)
      @reconcile_find = find.respond_to?(:call) ? find :
        ->(context) { where(find => context[:value]) }

      @reconcile_create = create

      if normalize.respond_to?(:call)
        @reconcile_normalize = normalize
      elsif normalize == :default
        @reconcile_normalize = ->(context) { context[:value].to_s.strip.gsub(/\s+/,'_').downcase }
      elsif normalize == :skip
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

      unless @reconcile_find.present?
        raise ArgumentError.new('Reconcile requires a reconcile_by find')
      end

      unless @reconcile_create.present?
        raise ArgumentError.new('Reconcile requires a reconcile_create create')
      end

      unless @reconcile_normalize.present?
        raise ArgumentError.new('Reconcile requires a reconcile_normalize normalize')
      end

      reconciler = Reconciler.new(self,
        find: @reconcile_find,
        create: @reconcile_create,
        normalize: @reconcile_normalize
      )

      reconciler.reconcile(context)
    end
  end
end
