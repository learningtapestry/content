class Repository < ActiveRecord::Base
  belongs_to :organization
  
  has_many :documents
  has_many :value_mappings

  def search_index
    @search_index ||= Search::Index.new(repository: self)
  end
end
