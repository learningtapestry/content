class FixJidColumns < ActiveRecord::Migration
  def change
    change_column :document_imports, :prepare_jid, :string
    change_column :document_imports, :mappings_jid, :string
    change_column :document_imports, :import_jid, :string
    change_column :document_exports, :export_jid, :string
  end
end
