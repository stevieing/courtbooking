module PermissionsHelpers

   def add_permissions(permissions, user)
    permissions.each do |permission|
      user.permissions.create(allowed_action_id: create(permission).id)
    end
  end

end