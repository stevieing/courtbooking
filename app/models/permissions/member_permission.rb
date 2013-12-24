module Permissions
  class MemberPermission < BasePermission
    def initialize(user)
      allow :courts, [:index]
      allow "devise/sessions", [:create, :destroy]
      allow_param :booking, [:time_and_place, :opponent_id, :opponent_name]
      user.permissions.each do |permission|
        if permission.allowed_action.user_specific
          allow permission.allowed_action.controller, permission.allowed_action.action do |booking|
            booking.user_id == user.id
          end
        else
          allow permission.allowed_action.controller, permission.allowed_action.action
        end
      end
    end
  end
end