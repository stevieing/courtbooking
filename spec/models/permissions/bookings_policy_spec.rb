require 'spec_helper'

describe Permissions::BookingsPolicy do

  before(:each) do
    stub_settings
  end

  let!(:user)           { create(:member)}
  let!(:standard_user)  { create(:member)}
  let!(:super_user)     { create(:admin)}
  let!(:admin_user)     { create(:member)}
  let!(:other_user)     { create(:member)}

  let!(:booking1)       {create(:booking, date_from: Date.today+1, time_from: "19:00", time_to: "19:30", user: standard_user)}
  let!(:booking2)       {create(:booking, date_from: Date.today+1, time_from: "19:30", time_to: "20:00", user: other_user)}
  let!(:booking3)       {create(:booking, date_from: Date.today+1, time_from: "20:00", time_to: "20:30")}
  let!(:booking4)       {create(:booking, date_from: Date.today+1, time_from: "21:00", time_to: "21:30")}
  let!(:booking5)       {create(:booking, date_from: Date.today+1, time_from: "21:30", time_to: "22:00")}

  before(:each) do
    add_standard_permissions standard_user
    add_admin_permissions admin_user
  end

  describe "bookings query" do

    context 'no permissions' do
      it { expect(Permissions::BookingsPolicy.new(user).bookings).to be_empty}
    end

    context 'standard permissions' do
      it { expect(Permissions::BookingsPolicy.new(standard_user).bookings).to have(1).item}
    end

    context 'admin permissions' do
      it { expect(Permissions::BookingsPolicy.new(super_user).bookings).to have(5).items}
    end

    context 'admin user' do
      it { expect(Permissions::BookingsPolicy.new(admin_user).bookings).to have(5).items}
    end
  end

  describe 'booking edit/delete' do

    context 'no permissions' do

      subject { Permissions::BookingsPolicy.new(user) }

      it { expect(subject.edit?(booking1)).to_not be_true}
      it { expect(subject.delete?(booking1)).to_not be_true}

    end

    context 'standard permissions' do

      subject { Permissions::BookingsPolicy.new(standard_user) }

      it { expect(subject.edit?(booking1)).to be_true}
      it { expect(subject.delete?(booking1)).to be_true}
      it { expect(subject.edit?(booking2)).to_not be_true}
      it { expect(subject.delete?(booking2)).to_not be_true}

    end

    context 'admin permissions' do

      subject { Permissions::BookingsPolicy.new(admin_user) }

      it { expect(subject.edit?(booking1)).to be_true}
      it { expect(subject.delete?(booking1)).to be_true}
      it { expect(subject.edit?(booking2)).to be_true}
      it { expect(subject.delete?(booking2)).to be_true}
      it { expect(subject.edit?(booking5)).to be_true}
      it { expect(subject.delete?(booking5)).to be_true}

    end

    context 'admin user' do

      subject { Permissions::BookingsPolicy.new(super_user) }

      it { expect(subject.edit?(booking1)).to be_true}
      it { expect(subject.delete?(booking1)).to be_true}
      it { expect(subject.edit?(booking2)).to be_true}
      it { expect(subject.delete?(booking2)).to be_true}
      it { expect(subject.edit?(booking5)).to be_true}
      it { expect(subject.delete?(booking5)).to be_true}

    end

    context 'in the past' do
      before(:each) do
        stub_dates(Date.today+1, "20:00")
     end

      subject { Permissions::BookingsPolicy.new(super_user) }

      it { expect(subject.edit?(booking1)).to be_false}
      it { expect(subject.delete?(booking1)).to be_false}
    end
  end

  describe 'params' do

    subject { Permissions::BookingsPolicy.new(user) }

    it { expect(subject.params(ActionController::Parameters.new(attributes_for(:booking)))).to be_permitted }
  end

  describe 'guest user' do
    subject { Permissions::BookingsPolicy.new(build(:guest)) }

    it { expect(subject.allow_all?).to be_false }
    it { expect(subject.bookings).to be_empty}

  end


end