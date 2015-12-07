class CreateUrls < ActiveRecord::Migration
  def change
    create_table :urls do |t|
      t.string :url, null: false
      t.integer :parent_id
      t.integer :last_status
      t.timestamp :checked_at
      t.timestamps null: false
    end

    add_index :urls, :url, unique: true
    add_index :urls, :parent_id
    add_foreign_key :urls, :urls, column: :parent_id
  end
end
