class Language < ActiveRecord::Base
  belongs_to :review_status
  
  has_many :document_languages
  has_many :documents, through: :document_languages

  include Reconcile

  reconcile_by ->(repo, val) { where(name: val) }
  reconcile_create ->(repo, val) { 
    create!(name: val, review_status: ReviewStatus.not_reviewed)
  }
end
