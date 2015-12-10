class ResourceType < ActiveRecord::Base
  acts_as_tree

  belongs_to :review_status
  
  has_many :document_resource_types
  has_many :documents, through: :document_resource_types
end
