class Subject < ActiveRecord::Base
  acts_as_tree
  
  belongs_to :review_status
  
  has_many :document_subjects
  has_many :documents, through: :document_subjects
end
