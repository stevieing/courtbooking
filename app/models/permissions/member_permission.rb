module Permissions
  class MemberPermission < BasePermission
    def initialize(user)
      allow :courts, [:index]
      allow "devise/sessions", [:create, :destroy]
      allow_param :booking, [:time_and_place, :opponent_id]
      user.permissions.each do |permission|
        if permission.allowed_action.user_specific
          allow permission.allowed_action.controller, permission.allowed_action.action do |booking|
            booking.user_id == user.id
          end
        else
          allow permission.allowed_action.controller, permission.allowed_action.action
        end
      end
     # allow :bookings, [:index, :new, :create, :show] 
     # allow :bookings, [:edit, :update, :destroy] do |booking|
     #   booking.user_id == user.id
     # end
      
    end
  end
end