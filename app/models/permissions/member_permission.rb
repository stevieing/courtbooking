##
#
# TODO: this probably needs to be refactored now
# move the permissions out to another class or method.
#

module Permissions
  class MemberPermission < BasePermission
    def initialize(user)
      @user = user
      allow_basic_permissions
      allow_param :booking, ACCEPTED_ATTRIBUTES.booking
      allow_param :user, ACCEPTED_ATTRIBUTES.current_user
      add_user_permissions
    end

    def allow_all?(controller, action)
      @user.permissions.includes(:allowed_action).select do |permission|
        permission.controller.to_s == controller.to_s &&
        permission.action.map(&:to_s).include?(action.to_s) &&
        permission.non_user_specific?
      end.any?
    end

    private

    def add_user_permissions
      @user.permissions.includes(:allowed_action).each do |permission|
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