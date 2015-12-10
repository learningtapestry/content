class DocumentImportRow < ActiveRecord::Base
  belongs_to :document_import

  def find_document
    find_document_with_same_id || find_document_with_same_url
  end

  def find_document_with_same_id
    content['id'].present? &&
      document_import
        .repository
        .documents
        .where(id: content['id'])
        .first
  end

  def find_document_with_same_url
    content['url'].present? &&
      document_import
        .repository
        .documents
        .find_by_url(content['url'])
  end

  #
  # CSV parsing methods
  #

  def parse_array_column(column)
    column.present? && column.to_s.split(',')
  end

  def parse_csv_content(row)
    self.content = {
      id: row['id'],

      title: row['title'],

      description: row['description'],

      grades: parse_array_column(row['grades']),

      languages: parse_array_column(row['languages']),

      publishers: parse_array_column(row['publishers']),

      resource_types: parse_array_column(row['resource_types']),

      subjects: parse_array_column(row['subjects']),

      standards: parse_array_column(row['standards']),

      url: row['url']
    }
  end

  #
  # Mapping methods
  #

  def map_content
    self.mappings = {
      grades: candidates_hash(content['grades'], :find_grades),

      languages: candidates_hash(content['languages'], :find_languages),

      publishers: candidates_hash(content['publishers'], :find_publishers),

      resource_types: candidates_hash(content['resource_types'], :find_resource_types),

      subjects: candidates_hash(content['subjects'], :find_subjects),

      standards: candidates_hash(content['standards'], :find_standards),

      url: candidates_hash(content['url'], :find_urls)
    }
  end

  def candidates_hash(column, finder_method)
    column = Array.wrap(column)
    h = {}
    column.each do |val|
      candidates = send(finder_method, val)
      h[val] = candidates if candidates.any?
    end
    h
  end

  def find_grades(grade)
    Grade.where(value: grade)
  end

  def find_publishers(publisher)
    Identity.where(name: publisher)
  end

  def find_languages(language)
    Language.where(value: language)
  end

  def find_resource_types(resource_type)
    ResourceType.where(value: resource_type)
  end

  def find_subjects(subject)
    Subject.where(value: subject)
  end

  def find_standards(standard)
    Standard.where(value: standard)
  end

  def find_urls(url)
    Url.where(url: url)
  end
end
