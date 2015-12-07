class CreateDocumentSubjects < ActiveRecord::Migration
  def change
    create_table :document_subjects do |t|
      t.references :document, index: true, foreign_key: true, null: false
      t.references :subject, index: true, foreign_key: true, null: false
      t.timestamps null: false
    end

    add_index :document_subjects, [:document_id, :subject_id], unique: true,
      name: 'idx_doc_subject_uniq'
  end
end
