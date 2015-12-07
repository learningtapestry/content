class CreateDocumentImportRows < ActiveRecord::Migration
  def change
    create_table :document_import_rows do |t|
      t.references :document_import, index: true, foreign_key: true, null: false
      t.jsonb :import_errors
      t.jsonb :content, null: false
      t.timestamps null: false
    end
  end
end
