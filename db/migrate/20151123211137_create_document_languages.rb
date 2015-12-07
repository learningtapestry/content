class CreateDocumentLanguages < ActiveRecord::Migration
  def change
    create_table :document_languages do |t|
      t.references :document, index: true, foreign_key: true, null: false
      t.references :language, index: true, foreign_key: true, null: false
      t.timestamps null: false
    end

    add_index :document_languages, [:document_id, :language_id], unique: true
  end
end
