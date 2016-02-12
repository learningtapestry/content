class API::LR::Root < Grape::API
  format :json

  mount API::LR::Publish => '/publish'
end
