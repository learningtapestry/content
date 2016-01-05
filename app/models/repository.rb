class Repository < ActiveRecord::Base
  after_commit :create_search_index!, on: :create

  belongs_to :organization
  
  has_many :documents
  has_many :value_mappings

  def search_index
    @search_index ||= Search::Index.new(repository: self)
  end

  def create_search_index!
    search_index.create_index!
    search_index
  end
end
