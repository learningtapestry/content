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
      grades: find_grades(content['grades']),

      languages: find_languages(content['languages']),

      publishers: find_publishers(content['publishers']),

      resource_types: find_resource_types(content['resource_types']),

      subjects: find_subjects(content['subjects']),

      standards: find_standards(content['standards']),

      url: find_urls(content['url'])
    }
  end

  def find_grades(grades)
    # nop
  end

  def find_publishers(publishers)
    # nop
  end

  def find_languages(languages)
    # nop
  end

  def find_resource_types(resource_types)
    # nop
  end

  def find_subjects(subjects)
    # nop
  end

  def find_standards(standards)
    # nop
  end

  def find_urls(urls)
    # nop
  end
end
