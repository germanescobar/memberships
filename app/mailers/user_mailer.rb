class UserMailer < ApplicationMailer
  def send_invitation(membership, inviter, token)
    @membership = membership
    @organization = membership.organization
    @inviter = inviter
    @token = token

    mail(to: membership.user.email, subject: "You have been invited to #{@organization.name} on Memberships")
  end
end
