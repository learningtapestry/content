class Grade < ActiveRecord::Base
  acts_as_tree
  
  belongs_to :parent
  
  has_many :document_grades
  has_many :documents, through: :document_grades
end
