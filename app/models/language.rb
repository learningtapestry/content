class Language < ActiveRecord::Base
  belongs_to :review_status
  
  has_many :document_languages
  has_many :documents, through: :document_languages

  include Reconcile

  reconcile_by :name
  reconcile_create ->(context) { 
    create!(name: context[:value], review_status: ReviewStatus.not_reviewed)
  }
end
