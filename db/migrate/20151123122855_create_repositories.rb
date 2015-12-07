class CreateRepositories < ActiveRecord::Migration
  def change
    create_table :repositories do |t|
      t.string :value, null: false, index: true
      t.string :name, null: false
      t.references :organization, index: true, foreign_key: true, null: false
      t.boolean :public, null: false
      t.timestamps null: false
    end

    add_index :repositories, [:value, :organization_id], unique: true
  end
end
