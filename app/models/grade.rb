class Grade < ActiveRecord::Base
  include Indexable
  include Reconcile

  acts_as_tree
  acts_as_indexed

  belongs_to :review_status

  has_many :document_grades
  has_many :documents, through: :document_grades

  validates :name, length: { maximum: 30 }

  reconciles(
    find: :name,
    normalize: :default,
    create: ->(context) {
      create!(name: context[:value], review_status: ReviewStatus.not_reviewed)
    }
  )
end
