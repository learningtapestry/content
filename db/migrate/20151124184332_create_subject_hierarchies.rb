class CreateSubjectHierarchies < ActiveRecord::Migration
  def change
    create_table :subject_hierarchies, id: false do |t|
      t.integer :ancestor_id, null: false
      t.integer :descendant_id, null: false
      t.integer :generations, null: false
    end

    add_index :subject_hierarchies, [:ancestor_id, :descendant_id, :generations],
      unique: true,
      name: "subject_anc_desc_idx"

    add_index :subject_hierarchies, [:descendant_id],
      name: "subject_desc_idx"
  end
end
