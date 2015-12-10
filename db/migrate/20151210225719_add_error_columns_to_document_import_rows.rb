class AddErrorColumnsToDocumentImportRows < ActiveRecord::Migration
  def change
    add_column :document_import_rows, :prepare_errors, :jsonb
    add_column :document_import_rows, :mapping_errors, :jsonb
  end
end
