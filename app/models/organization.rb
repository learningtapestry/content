class Organization < ActiveRecord::Base
  resourcify # Allows user roles to be scoped per Organization (using gem rolify)

  has_many :api_keys
  has_many :repositories
  has_many :roles, as: :resource

  def create_api_key
    api_key = api_keys.build
    api_key.generate_key
    api_key.save!
    api_key
  end

  def search
    @search ||= Search::Search.new(*repositories.map(&:search_index))
  end
end
