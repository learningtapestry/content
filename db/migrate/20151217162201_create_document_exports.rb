class CreateDocumentExports < ActiveRecord::Migration
  def change
    create_table :document_exports do |t|
      t.integer :export_jid
      t.datetime :exported_at
      t.references :repository, index: true, foreign_key: true, null: false
      t.string :file
      t.string :export_type, null: false
      t.text :filtered_ids, array: true, default: []

      t.timestamps null: false
    end
  end
end
