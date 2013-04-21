require "spec_helper"

describe Permissions::AdminPermission do
  subject { Permissions.permission_for(build(:user, admin: true)) }

  it "allows anything" do
    should allow(:any, :thing)
  end
end