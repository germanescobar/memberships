require "application_system_test_case"

class MembershipsTest < ApplicationSystemTestCase
  include Devise::Test::IntegrationHelpers

  test "admin can invite and revoke access to user" do
    sign_in users(:jhon)
    visit memberships_url

    click_on "New Membership"
    assert page.has_css?("#membership-modal")

    within "#membership-modal" do
      fill_in "Email", with: "brad@example.com"
      click_on "Send Invitation"
    end
    assert page.has_no_css?("#membership-modal")

    user = User.find_by(email: "brad@example.com")
    assert_not_nil user
    assert_equal organizations(:google), user.current_organization

    membership = user.memberships.first
    assert_not_nil membership

    assert page.has_css?("#membership-#{membership.id}")

    # check that an email was sent
    invite_email = ActionMailer::Base.deliveries.last
    assert_equal "You have been invited to #{organizations(:google).name} on Memberships", invite_email.subject
    assert_match /invitations|\/.+\/accept/, invite_email.body.to_s

    assert_difference 'Membership.count', -1 do
      within "#membership-#{membership.id}" do
        find("button.btn").click
        page.accept_confirm { click_on "Delete invitation" }
      end
      assert page.has_no_css?("#membership-#{membership.id}")
    end
  end

  test "user can invite existing user" do
    users(:jhon).update(current_organization: organizations(:apple))
    sign_in users(:jhon)
    visit memberships_url

    click_on "New Membership"
    assert page.has_css?("#membership-modal")

    within "#membership-modal" do
      fill_in "Email", with: users(:mary).email
      click_on "Send Invitation"
    end
    assert page.has_no_css?("#membership-modal")

    user = users(:mary)
    assert_not_nil user
    membership = user.membership_for(organizations(:apple))
    assert_not_nil membership

    assert page.has_css?("#membership-#{membership.id}")
  end

  test "new user can accept invitation" do
    user = users(:mary)
    visit accept_invitation_path(id: "nkRGpPDfLvFbXhgVLxFJ")

    assert page.has_content?("Activate Account")
    assert_equal activate_user_path(user), current_path

    fill_in "Choose a password", with: "test1234"
    fill_in "Confirm password", with: "test1234"
    click_on "Activate my account"

    assert page.has_content?("Congratulations! Your membership for #{organizations(:google).name} is now active")
    assert root_path, current_path
  end

  test "existing logged out user can accept invitation" do
    user = users(:peter)
    visit accept_invitation_path(id: "7v-Gsa8hS7yg7sSYhE16")

    assert page.has_content?("Login")
    assert_equal new_user_session_path, current_path

    fill_in "Email", with: user.email
    fill_in "Password", with: "pass1234"
    click_button "Log in"

    assert page.has_content?("Congratulations! Your membership for #{organizations(:apple).name} is now active")
  end

  test "existing logged in user can accept invitation" do
    user = users(:peter)
    sign_in(user)
    visit accept_invitation_path(id: "7v-Gsa8hS7yg7sSYhE16")

    assert page.has_content?("Congratulations! Your membership for #{organizations(:apple).name} is now active")
  end

  test "owner can grant and revoke membership" do
    sign_in users(:peter)
    visit memberships_url

    within "#membership-#{memberships(:google_user).id}" do
      find("button.btn").click
      page.accept_confirm { click_on "Grant admin privilege" }
      assert page.has_content?("Admin")
    end

    membership = memberships(:google_user).reload
    assert membership.admin?

    # revoke admin privilege
    within "#membership-#{memberships(:google_user).id}" do
      find("button.btn").click
      page.accept_confirm { click_on "Revoke admin privilege" }
      assert page.has_content?("User")
    end

    membership.reload
    assert membership.user?
  end
end
