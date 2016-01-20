class Refine::Reconcile::Root < Grape::API
  include Refine::Reconcile::Base
  
  # before do
  #   error!("401 Unauthorized", 401) unless authorized?
  # end

  mount Refine::Reconcile::Grades => '/grades'
end
