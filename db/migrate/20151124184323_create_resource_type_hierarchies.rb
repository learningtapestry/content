class CreateResourceTypeHierarchies < ActiveRecord::Migration
  def change
    create_table :resource_type_hierarchies, id: false do |t|
      t.integer :ancestor_id, null: false
      t.integer :descendant_id, null: false
      t.integer :generations, null: false
    end

    add_index :resource_type_hierarchies, [:ancestor_id, :descendant_id, :generations],
      unique: true,
      name: "resource_type_anc_desc_idx"

    add_index :resource_type_hierarchies, [:descendant_id],
      name: "resource_type_desc_idx"
  end
end
