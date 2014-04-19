module Permissions
  def self.permission_for(user)
    if user.nil?
      GuestPermission.new(nil)
    else
      "Permissions::#{user.class}Permission".constantize.new(user)
    end
  end
end