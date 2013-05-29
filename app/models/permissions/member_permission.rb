module Permissions
  class MemberPermission < BasePermission
    def initialize(user)
      allow :courts, [:index]
      allow :bookings, [:index, :new, :create, :show] 
      allow :bookings, [:edit, :update, :destroy] do |booking|
        booking.user_id == user.id
      end
      allow "devise/sessions", [:create, :destroy]
      allow_param :booking, [:time_and_place, :opponent_user_id]
    end
  end
end