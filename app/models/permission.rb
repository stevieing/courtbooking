class Permission < ActiveRecord::Base

  belongs_to :allowed_action
  belongs_to :user

  delegate :sanitized_controller, :user_specific?, :admin?, :name, :controller, :action, to: :allowed_action

end
