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

  def each_array_column(column)
    vals = column.present? && column.to_s.split(',')
    if vals
      vals.map do |val|
        yield val
      end
    end
  end

  def parse_csv_content(row)
    self.content = {
      id: row['id'],

      title: row['title'],

      description: row['description'],

      grades: each_array_column(row['grades']) { |v| find_grades(v) },

      languages: each_array_column(row['languages']) { |v| find_languages(v) },

      publishers: each_array_column(row['publishers']) { |v| find_publishers(v) },

      resource_types: each_array_column(row['resource_types']) { |v| find_resource_types(v) },

      subjects: each_array_column(row['subjects']) { |v| find_subjects(v) },

      standards: each_array_column(row['standards']) { |v| find_standards(v) },

      url: find_urls(row['url'])
    }
  end

  #
  # Content finder methods
  #

  def build_field_hash(value, candidate_ids)
    {
      value: value,
      candidate_ids: candidate_ids
    }
  end

  def find_grades(grade_val)
    build_field_hash(grade_val, [])
  end

  def find_publishers(publisher_val)
    build_field_hash(publisher_val, [])
  end

  def find_languages(language_val)
    build_field_hash(language_val, [])
  end

  def find_resource_types(resource_type_val)
    build_field_hash(resource_type_val, [])
  end

  def find_subjects(subject_val)
    build_field_hash(subject_val, [])
  end

  def find_standards(standard_val)
    build_field_hash(standard_val, [])
  end

  def find_urls(url_val)
    build_field_hash(url_val, [])
  end
end
