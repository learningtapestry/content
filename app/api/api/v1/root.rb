class API::V1::Root < Grape::API
  format :json
  formatter :json, Grape::Formatter::ActiveModelSerializers

  helpers API::V1::Helpers

  before { unauthorized! unless current_organization || swagger_root? }

  mount API::V1::Repositories => '/repositories'
  mount API::V1::Search => '/search'

  add_swagger_documentation(
    base_path: '/api/v1'
  )
end
