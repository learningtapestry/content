require 'active_support/concern'

# Defines a reconciler for the model. I.e:
#
#   class MyModel < ActiveRecord::Base
#     include Reconcilable
#   end
#
#   my_model = MyModel.new
#   my_model.reconciler  # => <MyModelReconciler>
#   my_model.reconcile(context, options)
#
module Reconcilable
  extend ActiveSupport::Concern

  included do
    # get the reconciler class for this model.
    # E.g: given the model `SomeModule::SomeModel`, it would point to `SomeModelReconciler`
    def self.reconciler
      @reconciler ||= "#{self.name.demodulize}Reconciler".constantize.new
    end

    # reconcile using the specific `reconciler` class.
    #
    # Params:
    #  :context: [Hash] containing :value (required) and :repository (optional)
    #  :options: options passed directly to the reconciler. Valid options are described bellow.
    #      - :find          => [lambda | callable] define a different find function
    #      - :create        => [lambda | callable] define a different create function
    #      - :normalize     => [lambda | callable] define a different normalize function
    #                          [:skip] skips normalization
    #      - :save_mappings => [bool] define if should save ValueMapping for the found entries
    #
    def self.reconcile(context, options={})
      # raise ArgumentError.new('Context requires a repository') unless context[:repository].present?

      raise ArgumentError.new('Context requires a value') unless context[:value].present?

      reconciler.reconcile(context, options)
    end
  end
end
