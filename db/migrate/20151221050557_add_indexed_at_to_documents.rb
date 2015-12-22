class AddIndexedAtToDocuments < ActiveRecord::Migration
  def change
    add_column :documents, :indexed_at, :datetime, index: true
  end
end
