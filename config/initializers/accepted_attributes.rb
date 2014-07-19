AcceptedAttributes.setup do |config|

  config.add :booking, :time_and_place, :opponent_id, :court_id, :date_from, :time_from, :time_to, :opponent_name
  config.add :setting, :value
  config.add :member, :username, :full_name, :email, :password, :password_confirmation, :mail_me, allowed_action_ids: []
  config.add :current_user, :username, :full_name, :email, :password, :password_confirmation, :mail_me
  config.add :court, :number
  config.add :closure, :description, :date_from, :date_to, :time_from, :time_to, :allow_removal, court_ids: []
  config.add :event, :description, :date_from, :date_to, :time_from, :time_to, :allow_removal, court_ids: []
  config.add :allowed_action, :name, :controller, :action_text, :user_specific, :admin
  config.add_nested :court, :opening_times, :day, :time_from, :time_to
  config.add_nested :court, :peak_times, :day, :time_from, :time_to

end

ACCEPTED_ATTRIBUTES ||= AcceptedAttributes.dup