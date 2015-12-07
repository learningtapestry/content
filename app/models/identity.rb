class Identity < ActiveRecord::Base
  has_many :document_identities
  has_many :documents, through: :document_identities
end
