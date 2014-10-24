class User < ActiveRecord::Base

  has_many :bookings
  has_many :permissions, dependent: :destroy
  has_many :allowed_actions, through: :permissions

  ##
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :timeoutable,
         :recoverable, :rememberable, :trackable, :validatable, authentication_keys: [:login]

  ##
  # Virtual attribute for authenticating by either username or email
  # This is in addition to a real persisted field like 'username'
  attr_accessor :login

  validates_presence_of :username, :full_name
  validates_uniqueness_of :username

  ##
  # Returns a list of users without the specified user ordered by name.
  scope :without_user, ->(user) { where.not(id: user.id).order(:full_name) }

  ##
  # Useful for autocomplete functions. Returns a list of users which contains the term that is passed.
  # Case insensitive.
  scope :by_term, ->(term) { where(User.arel_table[:full_name].matches("%#{term}%")) }

  ##
  # Returns a list of users except the specified user which contain the specified term.
  def self.names_from_term_except_user(user, term)
    without_user(user).by_term(term).pluck(:full_name)
  end

  ##
  # Added for completeness to prevent errors if a Base user is passed to permissions.
  def allow?(*args)
    false
  end

  ##
  # Allows users to sign in using their username.
  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where(["lower(username) = :value OR lower(email) = :value", { value: login.downcase }]).first
    else
      where(conditions).first
    end
  end

  ##
  # Order by username ascending.
  def self.ordered
    order(:username)
  end
end
