module Permissions

  ##
  # Permissions for an Admin user
  # will allow access to all actions and all parameters.
  class AdminPermission < BasePermission

    ##
    # Add permissions to allow access to all actions and parameters.
    def initialize(user)
      super
      allow_all
      allow_all_params
    end

  end
end