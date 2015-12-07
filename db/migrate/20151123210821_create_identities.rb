class CreateIdentities < ActiveRecord::Migration
  def change
    create_table :identities do |t|
      t.string :value, null: false
      t.string :name, null: false
      t.timestamps null: false
    end

    add_index :identities, :value, unique: true
  end
end
