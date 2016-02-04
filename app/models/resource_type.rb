class ResourceType < ActiveRecord::Base
  include Indexable
  include Reconcilable

  acts_as_tree
  acts_as_indexed

  belongs_to :review_status

  has_many :document_resource_types
  has_many :documents, through: :document_resource_types
end
