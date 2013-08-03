class Permission < ActiveRecord::Base
  
  belongs_to :allowed_action
  belongs_to :user

end
