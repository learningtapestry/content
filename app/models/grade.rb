class Grade < ActiveRecord::Base
  include Indexable
  include Reconcilable
  include Reviewable

  acts_as_tree
  acts_as_indexed

  has_many :document_grades
  has_many :documents, through: :document_grades

  validates :name, length: { maximum: 30 }
end
