class Organization < ActiveRecord::Base
  resourcify # Allows user roles to be scoped per Organization (using gem rolify)

  has_many :repositories
  has_many :roles, as: :resource

  def search
    @search ||= Search::Search.new(*repositories.map(&:search_index))
  end
end
