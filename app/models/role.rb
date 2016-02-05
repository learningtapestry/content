class Role < ActiveRecord::Base
  has_and_belongs_to_many :api_keys, :join_table => :api_keys_roles
  has_and_belongs_to_many :users, :join_table => :users_roles
  belongs_to :resource, :polymorphic => true

  validates :resource_type,
            :inclusion => { :in => Rolify.resource_types },
            :allow_nil => true

  scopify
end
