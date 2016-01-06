class API::V1::Documents < Grape::API
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

    optional :language_id,        type: Integer
    optional :language_name,      type: String

    optional :resource_type_id,   type: Integer
    optional :resource_type_name, type: String

    optional :standard_id,        type: Integer
    optional :standard_name,      type: String

    optional :subject_id,         type: Integer
    optional :subject_name,       type: String
  end

  get '/' do
    results = current_organization.search.search(declared_params)
    header 'X-Total', results.total_hits.to_s
    results.sources
  end
end
