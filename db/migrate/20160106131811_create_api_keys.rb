class CreateApiKeys < ActiveRecord::Migration
  def change
    create_table :api_keys do |t|
      t.references :organization, index: true, foreign_key: true, null: false
      t.string :key, null: false, index: true
      t.boolean :expired, null: false, default: false
      t.timestamps null: false
    end
  end
end
