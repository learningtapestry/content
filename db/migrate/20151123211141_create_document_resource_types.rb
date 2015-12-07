class CreateDocumentResourceTypes < ActiveRecord::Migration
  def change
    create_table :document_resource_types do |t|
      t.references :document, index: true, foreign_key: true, null: false
      t.references :resource_type, index: true, foreign_key: true, null: false
      t.timestamps null: false
    end

    add_index :document_resource_types, [:document_id, :resource_type_id], unique: true,
      name: 'idx_doc_res_typ_uniq'
  end
end
