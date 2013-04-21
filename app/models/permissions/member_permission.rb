module Permissions
  class MemberPermission < BasePermission
    def initialize(user)
      allow :home, [:index]
      allow :courts, [:index]
      allow :bookings, [:index]
      allow "devise/sessions", [:create, :destroy]
    end
  end
end