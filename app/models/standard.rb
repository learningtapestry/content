class Standard < ActiveRecord::Base
  acts_as_tree
  
  belongs_to :review_status
  belongs_to :standard_framework

  has_many :document_standards
  has_many :documents, through: :document_standards
end
