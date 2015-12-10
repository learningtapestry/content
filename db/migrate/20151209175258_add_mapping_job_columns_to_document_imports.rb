class AddMappingJobColumnsToDocumentImports < ActiveRecord::Migration
  def change
    add_column :document_imports, :mappings_jid, :integer
    add_column :document_imports, :mapped_at, :timestamp
  end
end
