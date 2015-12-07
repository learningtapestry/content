class CreateDocumentGrades < ActiveRecord::Migration
  def change
    create_table :document_grades do |t|
      t.references :document, index: true, foreign_key: true, null: false
      t.references :grade, index: true, foreign_key: true, null: false
      t.timestamps null: false
    end

    add_index :document_grades, [:document_id, :grade_id], unique: true,
      name: 'idx_doc_grd_uniq'
  end
end
