module Permissions

  ###
  # permissions for a Member
  # basic permissions will be added as per guest user.
  # Any other permissions are done on a by user basis basis loaded from the database.
  class MemberPermission < BasePermission
    def initialize(user)
      super
      @user = user
      @permissions = @user.permissions.includes(:allowed_action)
      allow_basic_permissions
      add_user_permissions
    end

    ##
    # will check whether the permissions allow all records for this action:
    # * does the permissions object contain permissions for this controller?
    # * does the permissions object contain permissions for this action?
    # * s the permission not user specific?
    def allow_all?(controller, action)
      @permissions.select do |permission|
        permission.controller == controller &&
        permission.action.include?(action) &&
        permission.non_user_specific?
      end.any?
    end

  private

    def add_user_permissions
     @permissions.each do |permission|
        add_action(permission)
        add_params(permission.sanitized_controller) if add_params?(permission)
      end
    end

    def add_params(*permissions)
      permissions.each do |permission|
        PERMITTED_ATTRIBUTES.send(permission).all.each do |p|
          if p.is_a?(Hash)
            p.each { |k, v| allow_param permission, k, v }
          else
            allow_param permission, p
          end
        end
      end
    end

    def add_params?(permission)
      unless @allowed_params.include?(permission.sanitized_controller) || permission.action == [:index] || permission.action == ["index"]
        permission.admin? || PERMITTED_ATTRIBUTES.respond_to?(permission.sanitized_controller)
      end
    end

    def add_action(permission)
      allow(permission.controller, permission.action, &add_block(permission))
    end

    def add_block(permission)
      permission.user_specific? ? proc { |object| @user.id == set_id(object) } : nil
    end

    def set_id(object)
      object.respond_to?(:user_id) ? object.user_id : object.id
    end
  end
end