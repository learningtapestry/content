class AuthenticatedController < ApplicationController
  before_action :authenticate_user!
  helper_method :current_organization

  def current_organization
    @organization ||= begin
      Organization.find(
        user_session[:organization_id] ||= current_user.organizations.first.id
      )
    end
  end
end
