require "spec_helper"

describe Permissions::AdminPermission do

  subject { Permissions.permission_for(build(:admin)) }

  it "allows anything" do
    should allow_action(:any, :thing)
    should allow_param(:any, :thing)
  end

  describe "modify all" do

    it { should allow_action(:bookings, :edit, build(:booking))}
  end



end