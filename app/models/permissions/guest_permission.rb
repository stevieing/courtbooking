module Permissions
  class GuestPermission < BasePermission
    def initialize
      allow "devise/sessions", [:new, :create]
      allow "devise/passwords", [:new, :create, :edit, :update]
      allow :courts, [:index]
    end
  end
end