class Repository < ActiveRecord::Base
  belongs_to :organization
  
  has_many :documents
  has_many :value_mappings
end
