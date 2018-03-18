class Invitation
  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations

  attr_reader :email, :admin, :organization

  validates :email, presence: true, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }
  validate :not_already_a_member

  def initialize(args={})
    @email = args[:email]
    @admin = args[:admin]
    @organization = args[:organization]
  end

  def create_membership
    return nil unless valid?

    user = find_or_create_user
    role = admin == "1" ? :admin : :user
    organization.memberships.create!(user: user, status: :pending, role: role)
  end

  def persisted?
    false
  end

  private
    def find_or_create_user
      user = User.find_by(email: email)
      user = create_user unless user
      user
    end

    def create_user
      raw_token, hashed_token = Devise.token_generator.generate(User, :reset_password_token)
      User.create(email: email,
            current_organization: organization,
            password: Devise.friendly_token)
    end

    def not_already_a_member
      user = User.find_by(email: email)
      if user && user.membership_for(organization)
        errors[:email] << "is already a member"
      end
    end
end
