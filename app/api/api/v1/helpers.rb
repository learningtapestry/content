require 'base64'

module API::V1::Helpers
  extend Grape::API::Helpers

  #
  # Authentication helpers
  #

  def check_roles(one_of: [], all: [])
    if one_of.any?
      found_one = false
      one_of.each do |role|
        if current_api_key.roles.where(name: role).any?
          found_one = true
          break
        end
      end
      unauthorized! unless found_one
    end

    if all.any?
      all.each do |role|
        unauthorized! unless current_api_key.roles.where(name: role).any?
      end
    end
  end

  def current_api_key
    @current_api_key ||= begin
      ak_header = headers['X-Api-Key']

      if ak_header && ak_header.start_with?('Basic ')
        ak_header = Base64.decode64(ak_header.split('Basic ')[1])
      end

      ak_header && ApiKey.find_by(key: ak_header)
    end
  end

  def current_organization
    @current_organization = current_api_key.try(:organization)
  end

  def swagger_root?
    request.path.start_with?('/api/v1/swagger_doc')
  end

  def unauthorized!
    error!("401 Unauthorized", 401)
  end

  #
  # Parameter helpers
  #

  params :pagination do
    optional :page,  type: Integer, default: 1
    optional :limit, type: Integer, default: 100
  end

  def declared_params
    @declared_params ||= declared(params)
  end

  alias_method :dparams, :declared_params

  #
  # Header helpers
  #

  def x_total(total)
    header 'X-Total', total.to_s
  end
end
