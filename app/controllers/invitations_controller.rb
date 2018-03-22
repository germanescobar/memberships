class InvitationsController < ApplicationController
  before_action :authenticate_user!, except: [:accept]
  before_action :require_organization!, except: [:accept]

  def new
    @invitation = Invitation.new
  end

  def create
    @invitation = Invitation.new(invitation_params)
    if @invitation.valid?
      membership = @invitation.create_membership
      membership.invite!(current_user)

      @pending_memberships = current_organization.memberships.pending
    end
  end

  def resend
    membership = current_organization.memberships.find(params[:id])

    UserMailer.send_invitation(membership, current_user)
    redirect_to memberships_path, notice: "The invitation was sent successfully"
  end

  def accept
    token = Devise.token_generator.digest(Membership, :invitation_token, params[:id])
    membership = Membership.find_by!(invitation_token: token)

    user, organization = membership.user, membership.organization

    sign_out(current_user) if current_user && current_user != user
    user.update(current_organization: organization) if user.current_organization != organization

    redirect_to path_for_membership(membership)
  end

  private
    def invitation_params
      params.require(:invitation).permit(:email, :admin).merge(organization: current_organization)
    end

    def path_for_membership(m)
      m.active? ? path_for_active_membership(m) : path_for_pending_membership(m)
    end

    def path_for_active_membership(m)
      flash[:notice] = "The membership is already active"
      root_path
    end

    def path_for_pending_membership(m)
      if user_signed_in?
        root_path
      elsif m.user.sign_in_count > 0
        new_user_session_path(email: m.user.email)
      else
        activate_user_path(m.user, invitation_token: m.invitation_token)
      end
    end
end
