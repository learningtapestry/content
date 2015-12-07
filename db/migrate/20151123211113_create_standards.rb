class CreateStandards < ActiveRecord::Migration
  def change
    create_table :standards do |t|
      t.string :value, null: false
      t.integer :parent_id
      t.string :name, null: false
      t.references :standard_framework, index: true, foreign_key: true, null: false
      t.string :url
      t.timestamps null: false
    end

    add_index :standards, [:value, :parent_id], unique: true
    add_foreign_key :standards, :standards, column: :parent_id
  end
end
