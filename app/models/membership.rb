# == Schema Information
#
# Table name: memberships
#
#  id              :integer          not null, primary key
#  organization_id :integer
#  user_id         :integer
#  status          :integer
#  role            :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class Membership < ApplicationRecord
  belongs_to :organization
  belongs_to :user

  enum status: [:pending, :active]
  enum role: [:owner, :admin, :user]
end
