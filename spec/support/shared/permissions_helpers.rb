module PermissionsHelpers
  def create_standard_permissions
    create_permissions standard_permissions
  end

  def standard_permissions
    [:bookings_index, :bookings_new, :bookings_show, :bookings_destroy, :bookings_edit, :user_edit, :users_index]
  end

  def admin_permissions
    [:admin_index, :manage_users, :manage_courts, :manage_closures, :manage_events, :manage_settings, :edit_all_bookings]
  end

  def create_permissions(permissions)
    permissions.each do |permission|
      create(permission)
    end
  end

  def add_standard_permissions(user)
    add_permissions(standard_permissions, user)
  end

  def add_admin_permissions(user)
    add_permissions(admin_permissions, user)
  end

  def add_permissions(permissions, user)
    permissions.each do |permission|
      user.permissions.create(allowed_action_id: find_or_create_allowed_action(permission).id)
    end
  end

  def find_or_create_allowed_action(permission)
    AllowedAction.find_by(name: build(permission).name) || create(permission)
  end
end