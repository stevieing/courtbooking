require "spec_helper"

describe Permissions::GuestPermission do

  subject { Permissions.permission_for(build(:guest)) }

  describe "as a guest" do

    it {should allow_action("devise/sessions", :new)}
    it {should allow_action("devise/sessions", :create)}
    it {should allow_action("devise/sessions", :destroy)}
    it {should allow_action("devise/passwords", :new)}
    it {should allow_action("devise/passwords", :create)}
    it {should allow_action("devise/passwords", :edit)}
    it {should allow_action("devise/passwords", :update)}
    it {should allow_action(:courts, :index)}

    describe 'modify all' do

      it { should_not allow_action(:bookings, :edit, build(:booking))}

    end

  end

end