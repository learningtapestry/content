class CreateOrganizations < ActiveRecord::Migration
  def change
    create_table :organizations do |t|
      t.string :value, null: false
      t.string :name, null: false
      t.timestamps null: false
    end

    add_index :organizations, :value, unique: true
  end
end
