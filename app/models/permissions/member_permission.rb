module Permissions
  class MemberPermission < BasePermission
    def initialize(user)
      allow :courts, [:index]
      allow :bookings, [:index, :new, :create]
      allow "devise/sessions", [:create, :destroy]
    end
  end
end