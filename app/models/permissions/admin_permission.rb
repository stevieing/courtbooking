module Permissions

  class AdminPermission < BasePermission
    def initialize(user)
      allow_all
      allow_all_params
    end

    def edit_all?(resource)
      true
    end

    def can_edit?(resource, object)
      true
    end

    def can_destroy?(resource, object)
      true
    end
  end
end