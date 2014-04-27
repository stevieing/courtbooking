module Permissions

  class AdminPermission < BasePermission
    def initialize(user)
      allow_all
      allow_all_params
    end

  end
end