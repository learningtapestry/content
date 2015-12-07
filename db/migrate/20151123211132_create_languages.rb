class CreateLanguages < ActiveRecord::Migration
  def change
    create_table :languages do |t|
      t.string :value, null: false
      t.timestamps null: false
    end

    add_index :languages, :value, unique: true
  end
end
