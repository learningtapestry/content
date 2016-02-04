require 'active_support/concern'

module Reconcilable
  extend ActiveSupport::Concern

  included do
    def self.reconciler
      @reconciler ||= "#{self.name.demodulize}Reconciler".constantize.new
    end

    def self.reconcile(context, options={})
      # raise ArgumentError.new('Context requires a repository') unless context[:repository].present?

      raise ArgumentError.new('Context requires a value') unless context[:value].present?

      reconciler.reconcile(context, options)
    end
  end
end
