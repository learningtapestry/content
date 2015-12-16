class CreateValueMappings < ActiveRecord::Migration
  def change
    create_table :value_mappings do |t|
      t.string :value, index: true, null: false
      t.references :repository, index: true, foreign_key: true, null: false
      t.integer :mappable_id, index: true, null: false
      t.string :mappable_type, index: true, null: false
      t.integer :rank, null: false

      t.timestamps null: false
    end
  end
end
