class ResourceType < ActiveRecord::Base
  include Indexable
  include Reconcilable
  include Reviewable

  acts_as_tree
  acts_as_indexed

  has_many :document_resource_types
  has_many :documents, through: :document_resource_types
end
