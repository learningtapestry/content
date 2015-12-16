class DocumentImportRow < ActiveRecord::Base
  belongs_to :document_import

  def parse_csv_content(row)
    self.content = {
      id:             prepare_content(row['id']),
      title:          prepare_content(row['title']),
      description:    prepare_content(row['description']),
      grades:         parse_array_column(row['grades']),
      languages:      parse_array_column(row['languages']),
      publishers:     parse_array_column(row['publishers']),
      resource_types: parse_array_column(row['resource_types']),
      subjects:       parse_array_column(row['subjects']),
      standards:      parse_array_column(row['standards']),
      url:            prepare_content(row['url'])
    }
  end

  def map_content
    self.mappings = {
      grades:         find_candidates(GradeMapper, content['grades']),
      languages:      find_candidates(LanguageMapper, content['languages']),
      publishers:     find_candidates(IdentityMapper, content['publishers']),
      resource_types: find_candidates(ResourceTypeMapper, content['resource_types']),
      subjects:       find_candidates(SubjectMapper, content['subjects']),
      standards:      find_candidates(StandardMapper, content['standards']),
      url:            find_candidates(UrlMapper, content['url'])
    }
  end

  def to_document
    doc = find_document || Document.new

    doc.description     = content['description']
    doc.document_status = DocumentStatus.unpublished
    doc.repository      = repository
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

  def repository
    document_import.repository
  end

  protected

  # CSV parsing

  def parse_array_column(column)
    column.present? && column.to_s.split(',').map { |v| prepare_content(v) }
  end

  def prepare_content(val)
    val.present? && val.strip
  end

  # Mapping

  def find_candidates(mapper_class, column)
    candidates = {}
    mapper = mapper_class.new(repository: repository)
    Array.wrap(column).each do |val|
      candidates[val] = mapper.find_mappings(val).map(&:id)
    end
    candidates
  end

  # Importing

  def find_document
    find_document_with_same_id || find_document_with_same_url
  end

  def find_document_with_same_id
    content['id'].present? &&
      repository
        .documents
        .where(id: content['id'])
        .first
  end

  def find_document_with_same_url
    content['url'].present? &&
      repository
        .documents
        .find_by_url(content['url'])
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
