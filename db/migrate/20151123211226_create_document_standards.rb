class CreateDocumentStandards < ActiveRecord::Migration
  def change
    create_table :document_standards do |t|
      t.references :document, index: true, foreign_key: true, null: false
      t.references :standard, index: true, foreign_key: true, null: false
      t.timestamps null: false
    end

    add_index :document_standards, [:document_id, :standard_id], unique: true,
      name: 'idx_doc_std_uniq'
  end
end
