class Reconciler
  # points to the corresponding model.
  # e.g: MyModelReconciler => MyModel
  def model
    @model ||= self.class.name.demodulize.gsub('Reconciler', '').constantize
  end

  # default find method.
  # Can be overridden on the subclass to specify behavior
  def find(context)
    model.where name: context[:value]
  end

  # default normalize method.
  # Can be overridden on the subclass to specify behavior
  def normalize(context)
    context[:value].to_s.strip.gsub(/\s+/,'_').downcase
  end

  # default create method.
  # Can be overridden on the subclass to specify behavior
  def create(context)
    model.create!(name: context[:value])
  end

  # encapsulates the `find`, `create` and `normalize` methods call to handle
  # specialization per reconcile operation.
  # I.e:
  #
  #   reconciler.reconcile context   # uses the default find, create and normalize for this class
  #
  #   reconciler.reconcile(context,
  #     find: ->(context) { MySearch.new.search(context[:value]) },  # uses this find method
  #     normalize: (context)-> { context[:value].upcase }            # uses this normalize method
  #  )
  #
  def method_call(method_name, context, options)
    if options[method_name] == :skip
      # for normalize return itself, for create and find do nothing
      method_name == :normalize ?  context[:value] : nil

    elsif options[method_name].respond_to?(:call)
      # if we defined on options a callable for this method, call it.
      options[method_name].call(context)

    else
      # else send the default method
      send(method_name, context)
    end
  end

  # reconcile
  #
  # Params:
  #  :context: [Hash] containing :value (required) and :repository (optional)
  #  :options: change reconciler behavior. Valid options are described bellow.
  #      - :find          => [lambda | callable] define a different find function
  #      - :create        => [lambda | callable] define a different create function
  #      - :normalize     => [lambda | callable] define a different normalize function
  #                          all 3 methods accept `:skip` for skipping that function
  #      - :save_mappings => [bool] define if should save ValueMapping for the found entries (default: true)
  #
  def reconcile(context, options={})
    # raise ArgumentError.new('Context requires a repository') unless context[:repository].present?
    raise ArgumentError.new('Context requires a value') unless context[:value].present?

    repo       = context[:repository]
    normalized = method_call(:normalize, context, options)

    # try to find a ValueMapping already saved
    value_mappings = repo.present? ? repo.value_mappings : ValueMapping
    reconciled = value_mappings
      .where(mappable_type: model)
      .where(value: normalized)
      .order(rank: :desc)
      .map(&:mappable)

    if reconciled.empty?
      # if does not have a value mapping, the uses the `find` method
      found = method_call(:find, context, options)

      # by default save mappings
      save_mappings = options.fetch(:save_mappings, true)

      if found.any?
        if save_mappings
          found.each do |f|
            value_mappings.create!(mappable: f, value: normalized, rank: 1)
          end
        end

        reconciled = found
      else
        # if didnt found anything, then call `create`
        created = method_call(:create, context, options)
        value_mappings.create!(mappable: created, value: normalized, rank: 1) if save_mappings && created

        reconciled = [created]
      end
    end

    reconciled
  end
end
