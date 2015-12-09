class AddMappingsToDocumentImportRow < ActiveRecord::Migration
  def change
    add_column :document_import_rows, :mappings, :jsonb
  end
end
