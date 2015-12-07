class CreateDocuments < ActiveRecord::Migration
  def change
    create_table :documents do |t|
      t.references :url, index: true, foreign_key: true, null: false
      t.references :repository, index: true, foreign_key: true, null: false
      t.references :document_status, index: true, foreign_key: true, null: false
      t.text :title, null: false
      t.text :description
      t.timestamps null: false
    end

    add_index :documents, [:repository_id, :url_id], unique: true
  end
end
