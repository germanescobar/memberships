class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def require_organization!
    if current_organization.nil?
      redirect_to current_user.organizations.any? ? organizations_path : new_organization_path
    elsif current_membership.pending?
      current_membership.accept_invitation!
      flash.now[:notice] = "Congratulations! Your membership for <strong>#{current_organization.name}</strong> is now active"
    end
  end

  def current_organization
    current_user.current_organization
  end
  helper_method :current_organization

  def current_membership
    current_user.membership_for(current_organization)
  end
  helper_method :current_membership
end
