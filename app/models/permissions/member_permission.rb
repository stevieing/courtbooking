##
#
# TODO: this probably needs to be refactored now
# move the permissions out to another class or method.
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
      @user.permissions.each do |permission|
        add_action(permission)
        add_params(permission) if permission.admin?
      end
    end

    def add_params(permission)
      allow_param permission.sanitized_controller, ACCEPTED_ATTRIBUTES.send(permission.sanitized_controller)
      add_nested_params(permission)
    end

    def add_nested_params(permission)
      ACCEPTED_ATTRIBUTES.nested.each do |nested|
        if permission.sanitized_controller == nested.name
          allow_nested_params nested.name, nested.association, nested.attributes
        end
      end
    end

    def add_action(permission)
      allow(permission.controller, permission.action, &add_block(permission))
    end

    def add_block(permission)
      permission.user_specific? ? proc { |object| @user.id == set_id(object) } : nil
    end

    def set_id(object)
      object.is_a?(Booking) ? object.user_id : object.id
    end
  end
end