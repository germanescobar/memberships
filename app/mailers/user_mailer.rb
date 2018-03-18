class UserMailer < ApplicationMailer
  def send_invitation(membership, inviter)
    @membership = membership
    @organization = membership.organization
    @inviter = inviter

    mail(to: membership.user.email, subject: "You have been invited to #{@organization.name} on ConvertLoop")
  end
end
