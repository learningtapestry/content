class CreateDocumentStatuses < ActiveRecord::Migration
  def change
    create_table :document_statuses do |t|
      t.string :value, null: false
      t.string :description
      t.timestamps null: false
    end

    add_index :document_statuses, :value, unique: true
  end
end
