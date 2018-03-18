# == Schema Information
#
# Table name: memberships
#
#  id                     :integer          not null, primary key
#  organization_id        :integer
#  user_id                :integer
#  status                 :integer
#  role                   :integer
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  invitation_token       :string
#  invited_at             :datetime
#  invited_by_id          :integer
#  invitation_accepted_at :datetime
#

class Membership < ApplicationRecord
  belongs_to :organization
  belongs_to :user
  belongs_to :invited_by, class_name: "User", optional: true

  enum status: [:pending, :active]
  enum role: [:owner, :admin, :user]

  validates :user, uniqueness: { scope: :organization }

  def invite!(inviter)
    raw_token, hashed_token = Devise.token_generator.generate(Membership, :invitation_token)
    update!(invitation_token: hashed_token, invited_at: DateTime.current,
        invited_by: inviter)

    UserMailer.send_invitation(self, inviter).deliver_now
  end

  def accept_invitation!
    update!(status: :active, invitation_accepted_at: DateTime.current, invitation_token: nil)
  end

  def owner_or_admin?
    owner? || admin?
  end

  def active_since
    return nil if pending?
    invitation_accepted_at || created_at
  end
end
