class StandardMapper < EntityMapper

  map_for Standard

  def create_candidate(standard_val)
    Standard.create!(
      name: standard_val,
      review_status: ReviewStatus.not_reviewed
    )
  end

  def find_candidates(standard_val)
    Standard.where(name: standard_val)
  end

end
