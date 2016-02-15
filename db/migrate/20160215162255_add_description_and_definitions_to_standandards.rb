class AddDescriptionAndDefinitionsToStandandards < ActiveRecord::Migration
  def change
    add_column :standards, :description, :string
    add_column :standards, :definitions, :text, array: true, default: []
  end
end
