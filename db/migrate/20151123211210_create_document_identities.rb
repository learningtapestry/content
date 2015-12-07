class CreateDocumentIdentities < ActiveRecord::Migration
  def change
    create_table :document_identities do |t|
      t.references :document, index: true, foreign_key: true, null: false
      t.references :identity, index: true, foreign_key: true, null: false
      t.references :identity_type, index: true, foreign_key: true, null: false
      t.timestamps null: false
    end

    add_index :document_identities, [:document_id, :identity_id, :identity_type_id], unique: true,
      name: 'idx_doc_idt_uniq'
  end
end
