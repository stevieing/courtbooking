module Permissions
  class AdminPermission < BasePermission
    def initialize(user)
      allow_all
      allow_param :booking, [:time_and_place, :opponent_id, :opponent_name]
      allow_param :setting, [:value]
      allow_param :user, [:username, :email, :password, :password_confirmation, :mail_me]
      #TODO: these should be on the same line. Must be a logic problem in Permissions module
      allow_param :court, [:number, :opening_times => [:day, :time_from, :time_to]]
      allow_param :court, [:peak_times => [:day, :time_from, :time_to]]
    end
  end
end