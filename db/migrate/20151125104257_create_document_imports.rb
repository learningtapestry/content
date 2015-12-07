class CreateDocumentImports < ActiveRecord::Migration
  def change
    create_table :document_imports do |t|
      t.integer :prepare_jid
      t.integer :import_jid
      t.boolean :prepared, null: false, default: false
      t.boolean :completed, null: false, default: false
      t.string :file, null: false
      t.references :repository, index: true, foreign_key: true, null: false
      t.timestamps null: false
    end
  end
end
