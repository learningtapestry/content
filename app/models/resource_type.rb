class ResourceType < ActiveRecord::Base
  acts_as_tree
  
  has_many :document_resource_types
  has_many :documents, through: :document_resource_types
end
