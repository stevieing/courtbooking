class UsersForm

  include BasicForm

  set_model :user, PERMITTED_ATTRIBUTES.user.whitelist

  validate :verify_user

  def submit(params)
    push_and_save( persisted? ? process_password(params) : params)
  end

private

  def save_objects
    run_transaction do
      user.save
    end
  end

  def verify_user
    check_for_errors user
  end

end