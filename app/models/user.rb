class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  rolify
  has_many :organizations, through: :roles, source: :resource, source_type: 'Organization'
end
