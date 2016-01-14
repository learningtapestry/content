class Standard < ActiveRecord::Base
  acts_as_tree
  
  belongs_to :review_status
  belongs_to :standard_framework

  has_many :document_standards
  has_many :documents, through: :document_standards

  include Reconcile

  reconcile_by :name
  reconcile_create ->(context) { 
    create!(name: context[:value], review_status: ReviewStatus.not_reviewed)
  }
  reconcile_normalize :default
end
