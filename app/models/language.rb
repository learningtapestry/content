class Language < ActiveRecord::Base
  belongs_to :review_status

  has_many :document_languages
  has_many :documents, through: :document_languages

  include Indexable
  include Reconcile

  index_class Search::Indexes::LanguageIndex

  reconciles(
    find: :name,
    normalize: :default,
    create: ->(context) {
      create!(name: context[:value], review_status: ReviewStatus.not_reviewed)
    }
  )
end
