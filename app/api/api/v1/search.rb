require 'search/search'

class API::V1::Search < Grape::API
  helpers API::V1::Helpers

  params do
    use :pagination

    optional :q,                  type: String
    optional :title,              type: String
    optional :description,        type: String

    optional :status,             type: String

    optional :grade_ids,          type: Array[Integer]
    optional :grade_name,         type: String

    optional :identity_ids,       type: Array[Integer]
    optional :identity_name,      type: String
    optional :identity_type,      type: String

    optional :language_ids,       type: Array[Integer]
    optional :language_name,      type: String

    optional :resource_type_ids,  type: Array[Integer]
    optional :resource_type_name, type: String

    optional :standard_ids,       type: Array[Integer]
    optional :standard_name,      type: String

    optional :subject_ids,        type: Array[Integer]
    optional :subject_name,       type: String

    optional :repository_ids,     type: Array[Integer]

    optional :show_facets,        type: Boolean
  end

  get '/' do
    repos = current_organization.repositories

    if dparams.repository_ids.present?
      repos = repos.where(id: dparams.repository_ids)
      raise ActiveRecord::RecordNotFound if repos.empty?
    end

    results = Search::Search.new(repos.search_indices).search(dparams)
    
    x_total results.total_hits
    results.display
  end
end
