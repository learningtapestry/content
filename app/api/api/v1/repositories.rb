class API::V1::Repositories < Grape::API
  helpers API::V1::Helpers

  helpers do
    def repositories
      current_organization.repositories
    end

    def find_repository
      repositories.find(params.id)
    end
  end

  params do
    use :pagination
    optional :name, type: String
  end

  get '/' do
    filtered_repos = repositories

    if declared_params.name.present?
      filtered_repos = filtered_repos.where_name(declared_params.name)
    end

    x_total filtered_repos.count
    filtered_repos.page(declared_params.page).per(declared_params.limit)
  end

  params do
    requires :name,   type: String
    requires :public, type: Boolean
  end

  post '/' do
    Repository.create(declared_params.merge(organization: current_organization))
  end

  get '/:id' do
    find_repository
  end

  params do
    requires :name,   type: String
    requires :public, type: Boolean
  end

  put '/:id' do
    find_repository.update(declared_params)
  end

  delete '/:id' do
    find_repository.destroy
  end
end
