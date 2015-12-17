require 'test_helper'

class DocumentImportRowTest < ActiveSupport::TestCase
  setup do
    @khan_csv  =   File.new(File.join(fixture_path, 'document_import', 'khan_new_docs.csv'))
    @khan_repo =   repositories(:khan)
    @khan_import = DocumentImport.create!(repository: @khan_repo, file: @khan_csv)
  end

  test '#parse_csv_content parses id' do
    row = DocumentImportRow.new
    content = { 'id' => '1' }

    row.parse_csv_content(content)

    assert_equal '1', row.content['id']
  end

  test '#parse_csv_content parses title' do
    row = DocumentImportRow.new
    content = { 'title' => 'test' }

    row.parse_csv_content(content)

    assert_equal 'test', row.content['title']
  end

  test '#parse_csv_content parses description' do
    row = DocumentImportRow.new
    content = { 'description' => 'test' }

    row.parse_csv_content(content)

    assert_equal 'test', row.content['description']
  end

  test '#parse_csv_content parses nil correctly' do
    row = DocumentImportRow.new
    content = { 'grades' => '' }

    row.parse_csv_content(content)

    assert_nil row.content['grades']
  end

  test '#parse_csv_content parses grades' do
    row = DocumentImportRow.new
    content = { 'grades' => 'grade 1, grade 2' }

    row.parse_csv_content(content)

    assert_same_elements ['grade 1', 'grade 2'], row.content['grades']
  end

  test '#parse_csv_content parses languages' do
    row = DocumentImportRow.new
    content = { 'languages' => 'en, pt' }

    row.parse_csv_content(content)

    assert_same_elements ['en', 'pt'], row.content['languages']
  end

  test '#parse_csv_content parses publishers' do
    row = DocumentImportRow.new
    content = { 'publishers' => 'Khan, Other' }

    row.parse_csv_content(content)

    assert_same_elements ['Khan', 'Other'], row.content['publishers']
  end

  test '#parse_csv_content parses resource types' do
    row = DocumentImportRow.new
    content = { 'resource_types' => 'lesson, video' }

    row.parse_csv_content(content)

    assert_same_elements ['lesson', 'video'], row.content['resource_types']
  end

  test '#parse_csv_content parses subjects' do
    row = DocumentImportRow.new
    content = { 'subjects' => 'history, geography' }

    row.parse_csv_content(content)

    assert_same_elements ['history', 'geography'], row.content['subjects']
  end

  test '#parse_csv_content parses standards' do
    row = DocumentImportRow.new
    content = { 'standards' => 'ccls.1.2.3, ccls.1.2.3.4' }

    row.parse_csv_content(content)

    assert_same_elements ['ccls.1.2.3', 'ccls.1.2.3.4'], row.content['standards']
  end

  test '#parse_csv_content parses url' do
    row = DocumentImportRow.new
    content = { 'url' => 'http://www.khanacademy.org' }

    row.parse_csv_content(content)

    assert_equal 'http://www.khanacademy.org', row.content['url']
  end

  test '#map_content maps grades' do
    row = DocumentImportRow.new
    row.document_import = DocumentImport.new(repository: @khan_repo)
    content = { 'grades' => 'grade 1, grade 120' }

    row.parse_csv_content(content)
    row.map_content

    grade_1 = grades(:grade_1)
    grade_120 = Grade.find_by(name: 'grade 120')

    assert_same_elements [grade_1.id], row.mappings['grades']['grade 1']
    assert_same_elements [grade_120.id], row.mappings['grades']['grade 120']
  end

  test '#map_content maps languages' do
    row = DocumentImportRow.new
    row.document_import = DocumentImport.new(repository: @khan_repo)
    content = { 'languages' => 'en, pt' }

    row.parse_csv_content(content)
    row.map_content

    en = languages(:en)
    pt = Language.find_by(name: 'pt')

    assert_same_elements [en.id], row.mappings['languages']['en']
    assert_same_elements [pt.id], row.mappings['languages']['pt']
  end

  test '#map_content maps identities' do
    row = DocumentImportRow.new
    row.document_import = DocumentImport.new(repository: @khan_repo)
    content = { 'publishers' => 'Khan Academy, smithsonian' }

    row.parse_csv_content(content)
    row.map_content

    khan = identities(:khan)
    smithsonian = Identity.find_by(name: 'smithsonian')

    assert_same_elements [khan.id], row.mappings['publishers']['Khan Academy']
    assert_same_elements [smithsonian.id], row.mappings['publishers']['smithsonian']
  end

  test '#map_content maps resource types' do
    row = DocumentImportRow.new
    row.document_import = DocumentImport.new(repository: @khan_repo)
    content = { 'resource_types' => 'video, lesson' }

    row.parse_csv_content(content)
    row.map_content

    lesson = resource_types(:lesson)
    video = ResourceType.find_by(name: 'video')

    assert_same_elements [lesson.id], row.mappings['resource_types']['lesson']
    assert_same_elements [video.id], row.mappings['resource_types']['video']
  end

  test '#map_content maps subjects' do
    row = DocumentImportRow.new
    row.document_import = DocumentImport.new(repository: @khan_repo)
    content = { 'subjects' => 'history, geography' }

    row.parse_csv_content(content)
    row.map_content

    history = subjects(:history)
    geography = Subject.find_by(name: 'geography')

    assert_same_elements [history.id], row.mappings['subjects']['history']
    assert_same_elements [geography.id], row.mappings['subjects']['geography']
  end

  test '#map_content maps standards' do
    row = DocumentImportRow.new
    row.document_import = DocumentImport.new(repository: @khan_repo)
    content = { 'standards' => 'ccls.1.2, ccls.3.4' }

    row.parse_csv_content(content)
    row.map_content

    ccls_1_2 = standards(:ccls_1_2)
    ccls_3_4 = Standard.find_by(name: 'ccls.3.4')

    assert_same_elements [ccls_1_2.id], row.mappings['standards']['ccls.1.2']
    assert_same_elements [ccls_3_4.id], row.mappings['standards']['ccls.3.4']
  end

  test '#map_content maps url' do
    row = DocumentImportRow.new
    row.document_import = DocumentImport.new(repository: @khan_repo)
    khan = urls(:khan_intro_algebra)
    content = { 'url' => khan.url }

    row.parse_csv_content(content)
    row.map_content

    assert_same_elements [khan.id], row.mappings['url'][khan.url]
  end

  test '#to_document imports title' do
    @khan_import.prepare_import
    @khan_import.create_mappings

    row = @khan_import.rows.first
    doc = row.to_document

    assert_equal 'History', doc.title
  end

  test '#to_document imports description' do
    @khan_import.prepare_import
    @khan_import.create_mappings

    row = @khan_import.rows.first
    doc = row.to_document

    assert_equal 'Khan History', doc.description
  end

  test '#to_document imports grades' do
    @khan_import.prepare_import
    @khan_import.create_mappings

    row = @khan_import.rows.first
    doc = row.to_document
    doc.save

    assert_equal 'Grade 1', doc.grades[0].name
    assert_equal 'Grade 2', doc.grades[1].name
  end

  test '#to_document imports languages' do
    @khan_import.prepare_import
    @khan_import.create_mappings

    row = @khan_import.rows.first
    doc = row.to_document
    doc.save

    assert_equal 'English', doc.languages[0].name
    assert_equal 'Spanish', doc.languages[1].name
  end

  test '#to_document imports resource_types' do
    @khan_import.prepare_import
    @khan_import.create_mappings

    row = @khan_import.rows.first
    doc = row.to_document
    doc.save

    assert_equal 'Lesson',        doc.resource_types[0].name
    assert_equal 'Resource Plan', doc.resource_types[1].name
  end

  test '#to_document imports standards' do
    @khan_import.prepare_import
    @khan_import.create_mappings

    row = @khan_import.rows.first
    doc = row.to_document
    doc.save

    assert_equal 'CCLS1', doc.standards[0].name
    assert_equal 'CCLS2', doc.standards[1].name
  end

  test '#to_document imports subjects' do
    @khan_import.prepare_import
    @khan_import.create_mappings

    row = @khan_import.rows.first
    doc = row.to_document
    doc.save

    assert_equal 'History',   doc.subjects[0].name
    assert_equal 'Geography', doc.subjects[1].name
  end

  test '#to_document imports publishers' do
    @khan_import.prepare_import
    @khan_import.create_mappings

    row = @khan_import.rows.first
    doc = row.to_document
    doc.save

    assert_equal 'Khan', doc.identities.order(name: :asc)[0].name
    assert_equal 'LR',   doc.identities.order(name: :asc)[1].name
    assert doc.document_identities.all? do |doc_idt|
      doc_idt.identity_type == IdentityType.publisher
    end
  end

  test '#to_document imports url' do
    @khan_import.prepare_import
    @khan_import.create_mappings

    row = @khan_import.rows.first
    doc = row.to_document
    doc.save

    assert_equal 'https://www.khanacademy.org/humanities/history', doc.url.url
  end

  test '#to_document sets repository' do
    @khan_import.prepare_import
    @khan_import.create_mappings

    row = @khan_import.rows.first
    doc = row.to_document

    assert_equal @khan_repo, doc.repository
  end

  test '#to_document sets document status' do
    @khan_import.prepare_import
    @khan_import.create_mappings

    row = @khan_import.rows.first
    doc = row.to_document
    
    assert_equal DocumentStatus.unpublished, doc.document_status
  end

  test '#to_document finds existing document' do
    @khan_import.prepare_import

    # Change the URL to a document that's already in the database.
    row = @khan_import.rows.first
    row.content['url'] = urls(:khan_intro_algebra).url
    row.save

    # Create the mappings
    @khan_import.create_mappings
    row.reload

    # Exercise
    doc = row.to_document

    refute doc.new_record?
  end
end
