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

require 'test_helper'

class MembershipTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
