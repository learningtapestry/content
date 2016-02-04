class Grade < ActiveRecord::Base
  include Indexable
  include Reconcilable

  acts_as_tree
  acts_as_indexed

  belongs_to :review_status

  has_many :document_grades
  has_many :documents, through: :document_grades

  validates :name, length: { maximum: 30 }
end
