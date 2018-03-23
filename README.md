# Memberships

This is an example that shows how to implement a multi-tenant application (i.e. a single application that supports multiple customers) that allows each user to create and belong to multiple organizations in Rails 5. Users can have different privileges to different organizations (e.g. be an administrator of an organization and a normal user of another).

For this example we are assuming three roles: owner, admin and user.

## Use cases

* Sign Up
* Login
* List the organizations the user belongs to
* Create and edit organization
* Switch to a different organization the user belongs to
* List memberships of an organization
* Accept the invitation to an organization

Owners and administrators have the following additional use cases:

* Invite new or existing user to the organization
* Resend invitation
* Revoke membership (except to herself and the owner)
* Grant admin privilege to a user (except to himself)
* Revoke admin privilege from a user (except to herself)

## Implementation details

We are using [Devise](https://github.com/plataformatec/devise) but we are adding two additional models:

* [Organization](app/models/organization.rb)
* [Membership](app/models/membership.rb)

We also created a virtual model called [Invitation](app/models/invitation.rb) that will allow us to manage the invitations.

The controllers are the following:

* [OrganizationsController](app/controllers/organizations_controller.rb) - used to manage the organizations.
* [InvitationsController](app/controllers/invitations_controller.rb) - used to create, resend and accept invitations.
* [MembershipsController](app/controllers/memberships_controller.rb) - used to change privileges and delete memberships.
* [UsersController](app/controllers/users_controller.rb) - used for activations of users (allow the new users to set a password).

Finally, we added a `current_organization_id` column to `User` that represents the organization that the user is currently working on.

For the views we used [Bootstrap 4].

We used SQLite for the database.

Finally, we wrote some integration tests. Ideally, you would want to refactor some of these tests as model and controller tests.

## Setup

The requirements for this project are the following:

* Ruby (I used version 2.4.1)
* Rails 5.1
* Node.js
* Yarn

First, clone the project with the following command:

```
$ git clone git@github.com:germanescobar/memberships.git
```

Then, install the dependencies with the following commands:

```
$ bundle
$ yarn install
```

Load the schema:

```
$ rails db:schema:load
```

That's it! Run the server:

```
$ rails s
```

Go to http://localhost:3000/ on your favorite browser. Sign up and create an organization.

## FAQ

**How is this different from devise_invitable?**

We checked [devise_invitable](https://github.com/scambra/devise_invitable) but it seems targeted to application-wide invitations, not scoped like we did here.

**How can I contribute to this project?**

You can open an issue first so we can discuss the change/improvement. You can also create a Pull Request once the issue is discussed, or for one of the opened issues.
