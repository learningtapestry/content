class Reconciler
  def model
    @model ||= self.class.name.demodulize.gsub('Reconciler', '').constantize
  end

  def find(context)
    model.where name: context[:value]
  end

  def normalize(context)
    context[:value].to_s.strip.gsub(/\s+/,'_').downcase
  end

  def create(context)
    false
  end

  def method_call(method_name, context, options)
    if options[method_name] == :skip
      method_name == :normalize ?  context[:value] : nil

    elsif options[method_name].respond_to?(:call)
      options[method_name].call(context)

    else
      send(method_name, context)
    end
  end

  def reconcile(context, options={})
    # raise ArgumentError.new('Context requires a repository') unless context[:repository].present?
    raise ArgumentError.new('Context requires a value') unless context[:value].present?

    repo       = context[:repository]
    normalized = method_call(:normalize, context, options)

    value_mappings = repo.present? ? repo.value_mappings : ValueMapping
    reconciled = value_mappings
      .where(mappable_type: model)
      .where(value: normalized)
      .order(rank: :desc)
      .map(&:mappable)

    if reconciled.empty?
      found = method_call(:find, context, options)

      save_mappings = options.fetch(:save_mappings, true)

      if found.any?
        if save_mappings
          found.each do |f|
            value_mappings.create!(mappable: f, value: normalized, rank: 1)
          end
        end

        reconciled = found
      else
        created = method_call(:create, context, options)

        if save_mappings
          value_mappings.create!(mappable: created, value: normalized, rank: 1)
        end

        reconciled = [created]
      end
    end

    reconciled
  end
end
