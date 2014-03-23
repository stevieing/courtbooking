class AdminUserForm
  include FormManager

  set_model :user, ACCEPTED_ATTRIBUTES.user
  delegate :permissions, to: :model
  validate :verify_user

  def process_parameters(params)
    persisted? ? process_password(params) : params
  end

  def include_action?(allowed_action)
    permissions.pluck(:allowed_action_id).include?(allowed_action.id)
  end
end