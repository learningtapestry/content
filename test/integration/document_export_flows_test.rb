require 'test_helper'
 
class DocumentImportFlowsTest < ActionDispatch::IntegrationTest
  setup do
    @repo = repositories(:khan)
    login_as users(:lt)
  end

  test 'exporting with blank repository fails' do
    visit '/document_exports/new'

    within '#new_document_export' do
      select 'csv', from: 'Export type'
      click_button 'Export'
    end

    assert_equal '/document_exports', current_path
    assert page.find('.document_export_repository .error').text.include? "can't be blank"
  end

  test 'exporting with blank export type fails' do
    visit '/document_exports/new'

    within '#new_document_export' do
      select 'Khan Academy', from: 'Repository'
      click_button 'Export'
    end

    assert_equal '/document_exports', current_path
    assert page.find('.document_export_export_type .error').text.include? "can't be blank"
  end

  test 'exporting a csv enqueues an export task' do
    import_sample_data

    visit '/document_exports/new'

    within '#new_document_export' do
      select 'Khan Academy', from: 'Repository'
      select 'csv', from: 'Export type'

      assert_difference 'DocumentExport.count', +1 do
        click_button 'Export'
      end
    end

    doc_export = DocumentExport.last
    assert_equal "/document_exports/#{doc_export.id}", current_path
    assert_equal @repo.documents.count,
      CSV.parse(File.read(doc_export.file), headers: true).size
    refute_nil   doc_export.exported_at
  end

  def import_sample_data
    # Store some documents so we can export them.
    DocumentImport.new(
      file: File.open(File.join(fixture_path, 'document_import', 'valid_sample_data_small.csv')),
      repository: @repo
    ).process
  end
end
