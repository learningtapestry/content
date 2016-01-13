class ResourceType < ActiveRecord::Base
  acts_as_tree

  belongs_to :review_status
  
  has_many :document_resource_types
  has_many :documents, through: :document_resource_types

  include Reconcile

  reconcile_by :name
  reconcile_create ->(context) { 
    create!(name: context[:value], review_status: ReviewStatus.not_reviewed)
  }
end
