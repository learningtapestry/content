class Organization < ActiveRecord::Base
  resourcify # Allows user roles to be scoped per Organization (using gem rolify)

  has_many :api_keys, dependent: :destroy, autosave: true

  has_many :repositories do
    def search_indices
      map(&:search_index)
    end
  end

  has_many :roles, as: :resource

  def create_api_key
    api_key = api_keys.build
    api_key.generate_key
    api_key
  end

  def new_search
    @search ||= Search::Search.new(*repositories.map(&:search_index))
  end
end
