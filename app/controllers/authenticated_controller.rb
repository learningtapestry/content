class AuthenticatedController < ApplicationController
  before_action :authenticate_user!
  before_action :find_organization

  def find_organization
    @organization ||= begin
      Organization.find(
        user_session[:organization_id] ||= current_user.organizations.first.id
      )
    end
  end
end
