require 'test_helper'
 
class DocumentImportFlowsTest < ActionDispatch::IntegrationTest
  setup do
    @valid_sample_data = File.join(fixture_path, 'document_import', 'valid_sample_data.csv')
    @bad_data          = File.join(fixture_path, 'document_import', 'bad_data.csv')
    @not_csv_data      = File.join(fixture_path, 'document_import', 'not_a_csv.csv')
    login_as users(:lt)
  end

  teardown do
    FileUtils.rm_rf(Dir["#{Rails.root}/public/uploads/[^.]*"])
  end

  test 'uploading with blank repository fails' do
    visit '/document_imports/new'

    within '#new_document_import' do
      attach_file 'File', @valid_sample_data
      click_button 'Upload'
    end

    assert_equal '/document_imports', current_path
    assert page.find('.document_import_repository .error').text.include? "can't be blank"
  end

  test 'uploading without blank file fails' do
    visit '/document_imports/new'

    within '#new_document_import' do
      select 'Blank Slates', from: 'Repository'
      click_button 'Upload'
    end

    assert_equal '/document_imports', current_path
    assert page.find('.document_import_file .error').text.include? "can't be blank"
  end

  test 'uploading a non-CSV file fails' do
    visit '/document_imports/new'

    within '#new_document_import' do
      attach_file 'File', @not_csv_data
      select 'Blank Slates', from: 'Repository'
      click_button 'Upload'
    end

    assert_equal '/document_imports', current_path
    assert page.find('.document_import_file .error').text.include? "File doesn't appear to be a valid CSV"
  end

  test 'uploading a bad CSV fails' do
    visit '/document_imports/new'

    within '#new_document_import' do
      select 'Blank Slates', from: 'Repository'
      attach_file 'File', @bad_data
      click_button 'Upload'
    end

    assert_equal '/document_imports', current_path
    assert page.find('.document_import_file .error').text.include? 'Headers should be'
  end

  test 'uploading a valid CSV creates a DocumentImport with rows' do
    visit '/document_imports/new'

    within '#new_document_import' do
      select 'Blank Slates', from: 'Repository'
      attach_file 'File', @valid_sample_data

      assert_difference 'DocumentImport.count', +1 do
        click_button 'Upload'
      end
    end

    doc_import = DocumentImport.last
    assert_equal "/document_imports/#{doc_import.id}/rows", current_path
    assert_equal 'http://nmaahc.si.edu/exhibitions/motto',  doc_import.rows.last.content['url']
    assert_equal 9, doc_import.rows.count
    refute_nil   doc_import.prepare_jid
    refute_nil   doc_import.prepared_at
    refute_nil   doc_import.mappings_jid
    refute_nil   doc_import.mapped_at
  end

end
