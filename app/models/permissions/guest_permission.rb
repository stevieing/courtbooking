module Permissions
  class GuestPermission < BasePermission
    def initialize(user)
      allow_basic_permissions
    end

  end
end