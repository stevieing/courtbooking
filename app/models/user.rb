class User < ActiveRecord::Base

  has_many :bookings
  has_many :permissions, dependent: :destroy
  has_many :allowed_actions, through: :permissions

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :timeoutable,
         :recoverable, :rememberable, :trackable, :validatable, authentication_keys: [:login]

  attr_accessor :login

  validates_presence_of :username, :full_name

  scope :without_user, ->(user) { where.not(id: user.id).order(:full_name) }
  scope :by_term, ->(term) { where(User.arel_table[:full_name].matches("%#{term}%")) }

  def self.names_from_term_except_user(user, term)
    without_user(user).by_term(term).pluck(:full_name)
  end

  def allow?(*args)
    false
  end

  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
      if login = conditions.delete(:login)
        where(conditions).where(["lower(username) = :value OR lower(email) = :value", { value: login.downcase }]).first
      else
        where(conditions).first
      end
  end

  def self.ordered
    order(:username)
  end
end
