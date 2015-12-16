class LanguageMapper < EntityMapper

  map_for Language

  def create_candidate(language_val)
    Language.create!(
      name: language_val,
      review_status: ReviewStatus.not_reviewed
    )
  end

  def find_candidates(language_val)
    Language.where(name: language_val)
  end

end
