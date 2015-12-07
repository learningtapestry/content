class CreateGrades < ActiveRecord::Migration
  def change
    create_table :grades do |t|
      t.string :value, null: false
      t.integer :parent_id
      t.timestamps null: false
    end

    add_index :grades, [:value, :parent_id], unique: true
    add_foreign_key :grades, :grades, column: :parent_id
  end
end
