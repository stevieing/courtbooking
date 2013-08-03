require "spec_helper"

describe Permissions::AdminPermission do
  subject { Permissions.permission_for(build(:user, admin: true)) }

  it "allows anything" do
    should allow_action(:any, :thing)
    should_not allow_param(:booking, :time_and_place)
    should allow_param(:booking, :playing_on_text)
    should allow_param(:booking, :playing_from)
    should allow_param(:booking, :playing_to)
    should allow_param(:booking, :court_number)
    should allow_param(:booking, :opponent_id)
    should allow_param(:booking, :user_id)
    should_not allow_param(:booking, :playing_on)
  end

end