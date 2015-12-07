class CreateSubjects < ActiveRecord::Migration
  def change
    create_table :subjects do |t|
      t.string :value, null: false
      t.integer :parent_id
      t.timestamps null: false
    end

    add_index :subjects, [:value, :parent_id], unique: true
    add_foreign_key :subjects, :subjects, column: :parent_id
  end
end
