module Permissions
  class AdminPermission < BasePermission
    def initialize(user)
      allow_all
      allow_param :booking, [:playing_at_text, :court_number, :opponent_user_id, :user_id]
    end
  end
end