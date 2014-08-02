module Permissions

  class AdminPermission < BasePermission
    def initialize(user)
      super
      allow_all
      allow_all_params
    end

  end
end