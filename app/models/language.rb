class Language < ActiveRecord::Base
  belongs_to :review_status
  
  has_many :document_languages
  has_many :documents, through: :document_languages
end
