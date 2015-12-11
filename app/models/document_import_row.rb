class DocumentImportRow < ActiveRecord::Base
  belongs_to :document_import

  # CSV parsing

  def parse_csv_content(row)
    self.content = {
      id: prepare_content(row['id']),

      title: prepare_content(row['title']),

      description: prepare_content(row['description']),

      grades: parse_array_column(row['grades']),

      languages: parse_array_column(row['languages']),

      publishers: parse_array_column(row['publishers']),

      resource_types: parse_array_column(row['resource_types']),

      subjects: parse_array_column(row['subjects']),

      standards: parse_array_column(row['standards']),

      url: prepare_content(row['url'])
    }
  end

  def parse_array_column(column)
    column.present? && column.to_s.split(',').map { |v| prepare_content(v) }
  end

  def prepare_content(val)
    val.present? && val.strip
  end

  # Mapping

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
    candidates = {}
    mapper = EntityMapper.new
    Array.wrap(column).each do |val|
      candidates[val] = mapper.send(finder_method, val).map(&:id)
    end
    candidates
  end

  # Importing

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

  def to_document
    doc = find_document || Document.new

    doc.description     = content['description']
    doc.document_status = DocumentStatus.unpublished
    doc.repository      = document_import.repository
    doc.title           = content['title']
    doc.url             = Url.find(mappings['url'].first[1][0])

    import_relation('grades',         doc.document_grades,         Grade)
    import_relation('languages',      doc.document_languages,      Language)
    import_relation('resource_types', doc.document_resource_types, ResourceType)
    import_relation('standards',      doc.document_standards,      Standard)
    import_relation('subjects',       doc.document_subjects,       Subject)
    import_relation('publishers',     doc.document_identities,     Identity) { 
      |idt| idt.identity_type = IdentityType.publisher
    }

    doc
  end

  def import_relation(field_name, association, entity)
    entity_assoc = entity.table_name.singularize
    field        = mappings[field_name]

    association.each(&:mark_for_destruction)

    field.each do |val, candidates|
      next unless candidate = (candidates.any? && candidates[0])

      imported = association.build(entity_assoc => entity.find(candidate))
      yield imported if block_given?
    end
  end
end
