class CreateIdentityTypes < ActiveRecord::Migration
  def change
    create_table :identity_types do |t|
      t.string :value, null: false
      t.timestamps null: false
    end

    add_index :identity_types, :value, unique: true
  end
end
