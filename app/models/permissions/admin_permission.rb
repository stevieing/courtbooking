module Permissions
  class AdminPermission < BasePermission
    def initialize(user)
      allow_all
      allow_param :booking, [:playing_on_text, :playing_from, :playing_to, :court_number, :opponent_id, :user_id]
      allow_param :setting, [:value]
      allow_param :user, [:username, :email, :password, :password_confirmation, :mail_me]
    end
  end
end