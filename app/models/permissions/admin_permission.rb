module Permissions
  class AdminPermission < BasePermission
    def initialize(user)
      allow_all
      allow_param :booking, [:playing_on_text, :playing_from, :playing_to, :court_number, :opponent_id, :user_id]
      allow_param :setting, [:value]
    end
  end
end