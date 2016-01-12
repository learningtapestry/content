require 'search/search'

class API::V1::Search < Grape::API
  helpers API::V1::Helpers

  params do
    use :pagination

    optional :q,                  type: String
    optional :title,              type: String
    optional :description,        type: String

    optional :status,             type: String

    optional :grade_id,           type: Integer
    optional :grade_name,         type: String

    optional :identity_id,        type: Integer
    optional :identity_name,      type: String
    optional :identity_type,      type: String

    optional :language_id,        type: Integer
    optional :language_name,      type: String

    optional :resource_type_id,   type: Integer
    optional :resource_type_name, type: String

    optional :standard_id,        type: Integer
    optional :standard_name,      type: String

    optional :subject_id,         type: Integer
    optional :subject_name,       type: String

    optional :repository_ids,     type: Array[Integer]
  end

  get '/' do
    repos = current_organization.repositories

    if dparams.repository_ids.present?
      repos = repos.where(id: dparams.repository_ids)
      raise ActiveRecord::RecordNotFound if repos.empty?
    end

    results = Search::Search.new(repos.search_indices).search(dparams)
    header 'X-Total', results.total_hits.to_s
    results.sources
  end
end
