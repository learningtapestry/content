class API::V1::Root < Grape::API
  format :json
  formatter :json, Grape::Formatter::ActiveModelSerializers

  helpers API::V1::Helpers
  
  before do
    error!("401 Unauthorized", 401) unless current_organization
  end

  mount API::V1::Documents => '/documents'
end
