class Grade < ActiveRecord::Base
  acts_as_tree

  belongs_to :review_status
  
  has_many :document_grades
  has_many :documents, through: :document_grades
end
