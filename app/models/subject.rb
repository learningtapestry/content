class Subject < ActiveRecord::Base
  acts_as_tree
  
  belongs_to :parent
  
  has_many :document_subjects
  has_many :documents, through: :document_subjects
end
