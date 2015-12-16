class IdentityMapper < EntityMapper

  map_for Identity

  def create_candidate(publisher_val)
    Identity.create!(
      name: publisher_val,
      review_status: ReviewStatus.not_reviewed
    )
  end

  def find_candidates(publisher_val)
    Identity.where(name: publisher_val)
  end

end
