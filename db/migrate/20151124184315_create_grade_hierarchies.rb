class CreateGradeHierarchies < ActiveRecord::Migration
  def change
    create_table :grade_hierarchies, id: false do |t|
      t.integer :ancestor_id, null: false
      t.integer :descendant_id, null: false
      t.integer :generations, null: false
    end

    add_index :grade_hierarchies, [:ancestor_id, :descendant_id, :generations],
      unique: true,
      name: "grade_anc_desc_idx"

    add_index :grade_hierarchies, [:descendant_id],
      name: "grade_desc_idx"
  end
end
