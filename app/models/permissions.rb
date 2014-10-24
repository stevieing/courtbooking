###
# An entry point for users permissions.
# It can either be used as a standalone to create a permissions object for a user
# or it can be included within a user model and the permissions will be carried
# round with that user.
#
# When included within a class it will delegate all of the appropriate methods to an instance of permission.
# Under the hood it will create a current_permissions instance variable by calling the +permission_for+ class
# method. This will be fired when +User.find(id)+ is called.
module Permissions

  ##
  # Creates a permissions object based on the type of user.
  #
  # Example:
  #  permissions = Permissions.permission_for(member)
  #  permissions.class = Permissions::MemberPermission
  def self.permission_for(user)
    "Permissions::#{user.class}Permission".constantize.new(user)
  end

  extend ActiveSupport::Concern

  included do
    delegate :allow?, :permit_params!, to: :current_permissions
    delegate :permit_new!, to: :current_permissions unless self.name == "Guest"
    include_after_find
  end

  module ClassMethods

    ##
    # If the find method of ActiveRecord is called a permissions object is created
    # for that user.
    def include_after_find
      if self.ancestors.include?(ActiveRecord::Base)
        after_find :add_current_permissions
      end
    end
  end

  ##
  # If the current_permissions variable exists retrieve it otherwise
  # create a new permissions object for the current user.
  def current_permissions
    @current_permissions ||= Permissions.permission_for(self)
  end

  ##
  # Add the current_permissions object to the user.
  def add_current_permissions
    @current_permissions = Permissions.permission_for(self)
  end

end