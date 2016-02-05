class Standard < ActiveRecord::Base
  include Indexable
  include Reconcilable

  acts_as_tree
  acts_as_indexed

  belongs_to :review_status
  belongs_to :standard_framework

  has_many :document_standards
  has_many :documents, through: :document_standards
end
