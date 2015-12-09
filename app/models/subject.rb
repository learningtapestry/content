class Subject < ActiveRecord::Base
  acts_as_tree
  
  has_many :document_subjects
  has_many :documents, through: :document_subjects
end
