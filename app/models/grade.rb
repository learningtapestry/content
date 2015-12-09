class Grade < ActiveRecord::Base
  acts_as_tree
  
  has_many :document_grades
  has_many :documents, through: :document_grades
end
