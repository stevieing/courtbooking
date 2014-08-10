class MembersForm

  include BasicForm

  set_model :member, PERMITTED_ATTRIBUTES.member.whitelist

  validate :verify_member

  def submit(params)
    save( persisted? ? process_password(params) : params)
  end

  def include_action?(allowed_action)
    member.permissions.pluck(:allowed_action_id).include?(allowed_action.id)
  end

private

  def save_objects
    run_transaction do
      member.save
    end
  end

  def verify_member
    check_for_errors member
  end

end