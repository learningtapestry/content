class Identity < ActiveRecord::Base
  belongs_to :review_status
  
  has_many :document_identities
  has_many :documents, through: :document_identities
end
