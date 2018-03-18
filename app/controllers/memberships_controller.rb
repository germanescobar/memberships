class MembershipsController < ApplicationController
  before_action :authenticate_user!
  before_action :require_organization!

  def index
    @active_memberships = current_organization.memberships.active
    @pending_memberships = current_organization.memberships.pending
  end

  def toggle_admin
    membership = current_organization.memberships.find(params[:id])

    membership.admin? ? membership.user! : membership.admin!
    redirect_to memberships_path, notice: "The change to the membership was successful"
  end

  def destroy
    membership = current_organization.memberships.find(params[:id])
    membership.destroy

    if membership.user.current_organization == membership.organization
      membership.user.update(current_organization: nil)
    end

    redirect_to memberships_path, notice: "The membership was deleted successfully"
  end
end
