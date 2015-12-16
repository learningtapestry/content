class GradeMapper < EntityMapper

  map_for Grade

  def create_candidate(grade_val)
    Grade.create!(
      name: grade_val,
      review_status: ReviewStatus.not_reviewed
    )
  end

  def find_candidates(grade_val)
    Grade.where(name: grade_val)
  end

end
