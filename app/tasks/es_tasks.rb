module ESTasks
  extend self

  # create all indices
  def create_indices
    [Grade, Language, ResourceType, Standard, Subject, Identity].each do |model|
      index = model.new.search_index
      unless index.index_exists?
        puts "==== Create index for #{model.name} => #{index.index_name}"
        index.create_index!
      end
    end
  end

  # Reset an index
  # (caution: this will wipe out everything previously indexed)
  def reset_index(model_name)
    model = model_name.classify.constantize
    index = model.new.search_index

    index.index_exists? ? index.reset_index! : index.create_index!
  end

  # index all entries from the db
  def index_all(model_name)
    model = model_name.classify.constantize
    index = model.new.search_index

    if index.index_exists?
      model.find_in_batches { |objs| index.bulk_index(objs) }
    else
      raise "Index does not exists #{index.index_name}"
    end
  end
end
