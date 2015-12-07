class CreateUrlHierarchies < ActiveRecord::Migration
  def change
    create_table :url_hierarchies, id: false do |t|
      t.integer :ancestor_id, null: false
      t.integer :descendant_id, null: false
      t.integer :generations, null: false
    end

    add_index :url_hierarchies, [:ancestor_id, :descendant_id, :generations],
      unique: true,
      name: "url_anc_desc_idx"

    add_index :url_hierarchies, [:descendant_id],
      name: "url_desc_idx"
  end
end
