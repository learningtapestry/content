class EntityMapper

  def initialize(repository:)
    @repository = repository
  end

  def self.map_for(mappable_type)
    @mappable_type = mappable_type
  end

  def self.mappable_type
    @mappable_type
  end

  def find_mappings(value)
    mappables = @repository
      .value_mappings
      .where(mappable_type: self.class.mappable_type)
      .where(value: normalize(value))
      .order(rank: :desc)
      .map(&:mappable)

    if mappables.empty?
      unmapped = find_candidates(value)

      if unmapped.any?
        unmapped.each_with_index { |u,i| create_mapping(u, value, i+1) }
        mappables = unmapped
      else
        new_mappable = create_candidate(value)
        create_mapping(new_mappable, value, 1)
        mappables = [new_mappable]
      end
    end

    mappables
  end

  protected

  def create_mapping(mappable_inst, value, rank)
    @repository.value_mappings.create!(
      mappable: mappable_inst,
      value: value,
      rank: rank
    )
  end

  def normalize(value)
    value = value.to_s
    value.strip.gsub(/\s+/,'_').downcase
  end
  
end
