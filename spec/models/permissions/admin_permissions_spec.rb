require "spec_helper"

describe Permissions::AdminPermission do
  subject { Permissions.permission_for(build(:user, admin: true)) }

  it "allows anything" do
    should allow_action(:any, :thing)
    should allow_param(:booking, :time_and_place)
    should_not allow_param(:booking, :playing_on_text)
    should_not allow_param(:booking, :court_number)
    should allow_param(:booking, :opponent_id)
    should_not allow_param(:booking, :user_id)
    should_not allow_param(:booking, :playing_on)
    should_not allow_param(:booking, :playing_from)
    should_not allow_param(:booking, :playing_to)
    should allow_param(:setting, :value)
    should allow_param(:user, :username)
    should allow_param(:user, :email)
    should allow_param(:user, :password)
    should allow_param(:user, :password_confirmation)
    should allow_param(:user, :mail_me)
    should allow_param(:court, :number)
    should allow_param(:court, :opening_times => [:day, :time_from, :time_to])
    should allow_param(:court, :peak_times => [:day, :time_from, :time_to])
  end

end