class Grade < ActiveRecord::Base
  acts_as_tree

  belongs_to :review_status
  
  has_many :document_grades
  has_many :documents, through: :document_grades

  include Reconcile

  reconcile_by ->(repo, val) { where(name: val) }
  reconcile_create ->(repo, val) { 
    create!(name: val, review_status: ReviewStatus.not_reviewed)
  }
end
