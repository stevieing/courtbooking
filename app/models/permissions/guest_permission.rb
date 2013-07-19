module Permissions
  class GuestPermission < BasePermission
    def initialize
      allow "devise/sessions", [:new, :create]
      allow :courts, [:index] 
    end
  end
end