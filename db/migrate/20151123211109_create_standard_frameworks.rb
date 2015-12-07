class CreateStandardFrameworks < ActiveRecord::Migration
  def change
    create_table :standard_frameworks do |t|
      t.string :value, null: false
      t.string :name, null: false
      t.timestamps null: false
    end

    add_index :standard_frameworks, :value, unique: true
  end
end
