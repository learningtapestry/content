class ResourceType < ActiveRecord::Base
  acts_as_tree

  belongs_to :review_status

  has_many :document_resource_types
  has_many :documents, through: :document_resource_types

  include Indexable
  include Reconcile

  index_class Search::Indexes::ResourceTypeIndex

  reconciles(
    find: :name,
    normalize: :default,
    create: ->(context) {
      create!(name: context[:value], review_status: ReviewStatus.not_reviewed)
    }
  )
end
