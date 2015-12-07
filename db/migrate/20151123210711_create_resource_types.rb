class CreateResourceTypes < ActiveRecord::Migration
  def change
    create_table :resource_types do |t|
      t.string :value, null: false
      t.integer :parent_id
      t.timestamps null: false
    end

    add_index :resource_types, [:value, :parent_id], unique: true
    add_foreign_key :resource_types, :resource_types, column: :parent_id
  end
end
