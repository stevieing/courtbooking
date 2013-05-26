class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable, :authentication_keys => [:login]

  # Setup accessible (or protected) attributes for your model
  attr_accessible :username, :email, :password, :password_confirmation, :remember_me, :login, :admin
  # attr_accessible :title, :body
  
  attr_accessor :login
  
  validates_presence_of :username
  
  scope :without_user, lambda{|user| user ? {:conditions => ["id != ?", user.id]} : {} }
  
  class << self
    def username(id)
      find(id).username
    end
  end
     
  
  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
      if login = conditions.delete(:login)
        where(conditions).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
      else
        where(conditions).first
      end
  end
end
