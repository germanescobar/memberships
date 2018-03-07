# == Schema Information
#
# Table name: organizations
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Organization < ApplicationRecord
  has_many :memberships
  has_many :users, through: :memberships
  has_one :owner_membership, -> { where(role: :owner) }, class_name: "Membership"
  has_one :owner, through: :owner_membership, source: :user
end
