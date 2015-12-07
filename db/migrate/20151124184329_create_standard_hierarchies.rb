class CreateStandardHierarchies < ActiveRecord::Migration
  def change
    create_table :standard_hierarchies, id: false do |t|
      t.integer :ancestor_id, null: false
      t.integer :descendant_id, null: false
      t.integer :generations, null: false
    end

    add_index :standard_hierarchies, [:ancestor_id, :descendant_id, :generations],
      unique: true,
      name: "standard_anc_desc_idx"

    add_index :standard_hierarchies, [:descendant_id],
      name: "standard_desc_idx"
  end
end
