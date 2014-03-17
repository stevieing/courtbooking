##
#
# TODO: this probably needs to be refactored now
# move the persmissions out to another class or method.
#

module Permissions
  class MemberPermission < BasePermission
    def initialize(user)
      @user = user
      allow :courts, [:index]
      allow "devise/sessions", [:create, :destroy]
      allow_param :booking, [:time_and_place, :opponent_id]
      allow_param :user, ACCEPTED_ATTRIBUTES.current_user
      add_user_permissions
    end

    private

    def add_user_permissions
      @user.permissions.each { |permission| add_action(permission) }
    end

    def add_action(permission)
      allow(permission.allowed_action.controller, permission.allowed_action.action, &add_block(permission))
    end

    def add_block(permission)
      permission.allowed_action.user_specific ? proc { |object| @user.id == set_id(object) } : nil
    end

    def set_id(object)
      object.is_a?(Booking) ? object.user_id : object.id
    end
  end
end