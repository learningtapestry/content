class API::V1::Root < Grape::API
  format :json
  formatter :json, Grape::Formatter::ActiveModelSerializers

  helpers API::V1::Helpers

  before { unauthorized! unless current_organization }

  mount API::V1::Repositories => '/repositories'
  mount API::V1::Search => '/search'
end
