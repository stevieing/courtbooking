module Permissions
  class AdminPermission < BasePermission
    def initialize(user)
      allow_all
      allow_param :booking, [:time_and_place, :opponent_id]
      allow_param :setting, [:value]
      allow_param :user, [:username, :email, :password, :password_confirmation, :mail_me]
    end
  end
end