class AdminMemberForm
  include FormManager

  set_model :member, PERMITTED_ATTRIBUTES.member.whitelist
  delegate :permissions, to: :model
  validate :verify_member

  def process_parameters(params)
    persisted? ? process_password(params) : params
  end

  def include_action?(allowed_action)
    permissions.pluck(:allowed_action_id).include?(allowed_action.id)
  end
end