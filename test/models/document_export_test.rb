require 'test_helper'

class DocumentExportTest < ActiveSupport::TestCase
  setup do
    @repo = repositories(:empty)
  end

  test '#export exports a CSV' do
    import_sample_data

    doc_export = DocumentExport.new(
      repository: @repo,
      export_type: 'csv'
    )
    doc_export.export
    @repo.reload

    contents = CSV.parse(File.read(doc_export.file), headers: true)
    assert_equal @repo.documents.count, contents.size

    first_row = contents[0]
    doc = Document.find_by_url(first_row['url'])
    assert_equal doc.title, first_row['title']
    assert_equal doc.description, first_row['description']
    assert_same_elements doc.grades.pluck(:name), first_row['grades'].split(',')
    assert_same_elements doc.grades.pluck(:name), first_row['grades'].split(',')
    assert_same_elements doc.publishers.pluck(:name), first_row['publishers'].split(',')
    assert_same_elements doc.languages.pluck(:name), first_row['languages'].split(',')
    assert_same_elements doc.resource_types.pluck(:name), first_row['resource_types'].split(',')
    assert_same_elements doc.standards.pluck(:name), first_row['standards'].split(',')
    assert_same_elements doc.subjects.pluck(:name), first_row['subjects'].split(',')
  end

  # Store some documents so we can export them.
  def import_sample_data
    DocumentImport.new(
      file: File.open(File.join(fixture_path, 'document_import', 'valid_sample_data_small.csv')),
      repository: @repo
    ).process
  end
end
