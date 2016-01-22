class CreateApiKeysRoles < ActiveRecord::Migration
  def change
    create_table :api_keys_roles do |t|
      t.references :api_key, index: true, foreign_key: true
      t.references :role, index: true, foreign_key: true
    end

    add_index(:api_keys_roles, [ :api_key_id, :role_id ])
  end
end
