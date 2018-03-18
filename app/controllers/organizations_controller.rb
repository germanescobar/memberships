class OrganizationsController < ApplicationController
  before_action :authenticate_user!

  def index
    @organizations = current_user.organizations
  end

  def new
    @organization = current_user.owned_organizations.build
  end

  def create
    @organization = current_user.owned_organizations.buld(organization_params)
    if @organization.save
      @organization.owner = current_user
      current_user.update(current_organization: @organization)
      redirect_to root_path, notice: "The organization was created successfully"
    else
      render :new
    end
  end

  def edit
    @organization = current_user.organizations.find(params[:id])
  end

  def update
    organization = current_user.organizations.find(params[:id])
    if organization.update(organization_params)
      redirect_to organizations_path, notice: "The organization was updated successfully"
    end
  end

  protected
    def organization_params
      params.require(:organization).permit(:name)
    end
end
