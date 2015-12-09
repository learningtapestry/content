class FixDocumentImportStatusColumns < ActiveRecord::Migration
  def change
    remove_column :document_imports, :prepared
    remove_column :document_imports, :completed

    add_column :document_imports, :prepared_at, :timestamp
    add_column :document_imports, :imported_at, :timestamp
  end
end
