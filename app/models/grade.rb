class Grade < ActiveRecord::Base
  acts_as_tree

  belongs_to :review_status
  
  has_many :document_grades
  has_many :documents, through: :document_grades

  validates :name, length: { maximum: 30 }

  include Reconcile

  reconciles(
    find: :name,
    normalize: :default,
    create: ->(context) { 
      create!(name: context[:value], review_status: ReviewStatus.not_reviewed)
    }
  )
end
