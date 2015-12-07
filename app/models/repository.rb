class Repository < ActiveRecord::Base
  belongs_to :organization
  
  has_many :documents
end
