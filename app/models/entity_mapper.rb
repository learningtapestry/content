class EntityMapper

  #
  # Grades
  #

  def find_grades(grade_val)
    candidate = Grade
      .create_with(review_status: ReviewStatus.not_reviewed)
      .where(value: grade_val)
      .first_or_create!

    [candidate]
  end

  #
  # Languages
  #

  def find_languages(language_val)
    candidate = Language
      .create_with(review_status: ReviewStatus.not_reviewed)
      .where(value: language_val)
      .first_or_create!

    [candidate]
  end

  #
  # Publisher
  #

  def find_publishers(publisher_val)
    candidate = Identity
      .create_with(review_status: ReviewStatus.not_reviewed, name: publisher_val)
      .where(value: publisher_val)
      .first_or_create!

    [candidate]
  end

  #
  # Resource type
  #
  
  def find_resource_types(resource_type_val)
    candidate = ResourceType
      .create_with(review_status: ReviewStatus.not_reviewed)
      .where(value: resource_type_val)
      .first_or_create!

    [candidate]
  end

  #
  # Subject
  #
  
  def find_subjects(subject_val)
    candidate = Subject
      .create_with(review_status: ReviewStatus.not_reviewed)
      .where(value: subject_val)
      .first_or_create!

    [candidate]
  end

  #
  # Standard
  #
  
  def find_standards(standard_val)
    candidate = Standard
      .create_with(review_status: ReviewStatus.not_reviewed, name: standard_val)
      .where(value: standard_val)
      .first_or_create!

    [candidate]
  end

  #
  # URL
  #
  
  def find_urls(url_val)
    candidate = Url
      .create_with(review_status: ReviewStatus.not_reviewed)
      .where(url: url_val)
      .first_or_create!

    [candidate]
  end
  
end
