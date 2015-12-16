class ResourceTypeMapper < EntityMapper

  map_for ResourceType

  def create_candidate(resource_type_val)
    ResourceType.create!(
      name: resource_type_val,
      review_status: ReviewStatus.not_reviewed
    )
  end

  def find_candidates(resource_type_val)
    ResourceType.where(name: resource_type_val)
  end

end
