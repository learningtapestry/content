class RemoveValueColumns < ActiveRecord::Migration
  def change
    # Grades
    remove_column :grades, :value
    add_column :grades, :name, :string

    # Identities
    remove_column :identities, :value

    # Languages
    remove_column :languages, :value
    add_column :languages, :name, :string
    
    # Organizations
    remove_column :organizations, :value

    # Repositories
    remove_column :repositories, :value

    # Resource types
    remove_column :resource_types, :value
    add_column :resource_types, :name, :string    

    # Standards
    remove_column :standards, :value

    # Subjects
    remove_column :subjects, :value
    add_column :subjects, :name, :string
  end
end
