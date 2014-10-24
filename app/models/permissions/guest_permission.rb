module Permissions

  ###
  # permissions for a Guest user.
  # will allow access to basic actions such as sign_in or courts/index
  class GuestPermission < BasePermission
    def initialize(user)
      super
      allow_basic_permissions
    end

  end
end