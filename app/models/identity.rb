class Identity < ActiveRecord::Base
  belongs_to :review_status
  
  has_many :document_identities
  has_many :documents, through: :document_identities

  include Reconcile

  reconcile_by :name
  reconcile_create ->(context) { 
    create!(name: context[:value], review_status: ReviewStatus.not_reviewed)
  }
  reconcile_normalize :default
end
