class Identity < ActiveRecord::Base
  belongs_to :review_status
  
  has_many :document_identities
  has_many :documents, through: :document_identities

  include Reconcile

  reconciles(
    find: :name,
    normalize: :default,
    create: ->(context) { 
      create!(name: context[:value], review_status: ReviewStatus.not_reviewed)
    }
  )
end
