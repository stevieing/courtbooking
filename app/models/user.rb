class User < ActiveRecord::Base
  
  has_many :bookings, dependent: :destroy
  has_many :permissions, dependent: :destroy
  
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable, authentication_keys: [:login]
  
  attr_accessor :login
  
  validates_presence_of :username, :full_name
  
  scope :without_user, ->(user) { where.not(id: user.id) }
  
  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
      if login = conditions.delete(:login)
        where(conditions).where(["lower(username) = :value OR lower(email) = :value", { value: login.downcase }]).first
      else
        where(conditions).first
      end
  end
end
