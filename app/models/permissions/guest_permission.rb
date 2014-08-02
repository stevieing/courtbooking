module Permissions
  class GuestPermission < BasePermission
    def initialize(user)
      super
      allow_basic_permissions
    end

  end
end