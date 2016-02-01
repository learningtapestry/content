class Subject < ActiveRecord::Base
  acts_as_tree

  belongs_to :review_status

  has_many :document_subjects
  has_many :documents, through: :document_subjects

  include Indexable
  include Reconcile

  index_class Search::Indexes::SubjectIndex

  reconciles(
    find: :name,
    normalize: :default,
    create: ->(context) {
      create!(name: context[:value], review_status: ReviewStatus.not_reviewed)
    }
  )
end
