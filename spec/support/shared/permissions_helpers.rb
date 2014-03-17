module PermissionsHelpers
  def create_standard_permissions
    [:bookings_index, :bookings_new, :bookings_show, :bookings_destroy, :bookings_edit, :user_edit].each do |factory|
      create(factory)
    end
  end

  def add_standard_permissions(user)
    create_standard_permissions unless AllowedAction.any?
    AllowedAction.all.each do |action|
      user.permissions.create(allowed_action_id: action.id)
    end
  end
end