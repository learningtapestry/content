class SubjectMapper < EntityMapper

  map_for Subject

  def create_candidate(subject_val)
    Subject.create!(
      name: subject_val,
      review_status: ReviewStatus.not_reviewed
    )
  end

  def find_candidates(subject_val)
    Subject.where(name: subject_val)
  end

end
