require 'spec_helper'

describe BookingSlots::Properties do

	before(:each) do
		stub_settings
	end

	let!(:user) 				{ create(:user)}
	let!(:other_user)		{ create(:user)}
	let!(:edit_action)	{ create(:bookings_edit)}
	let(:date)					{ Date.today}
	
	subject 		{ BookingSlots::Properties.new(date, user)}

	its(:user)	{ should eq(user)}
	its(:date)	{ should eq(date)}

	describe "edit booking" do

		context "guest user" do

			let(:booking)			{ build(:booking) }
			subject { BookingSlots::Properties.new(date, nil)}

			it { expect(subject.edit_booking? booking).to be_false }
		end

		context "without edit permissions" do

			let(:booking)			{ build(:booking, user: user) }
			it { expect(subject.edit_booking? booking).to be_false }
			it { expect(booking).to be_valid}
		end

		context "allowed" do
			let!(:permissions)		{ user.permissions.create(allowed_action: create(:bookings_edit))}
			let(:booking)					{ build(:booking, user_id: user.id) }
			subject  							{ BookingSlots::Properties.new(date, user)}
			
			it { expect(subject.edit_booking? booking).to be_true }

		end

		context "for somebody else" do
			let!(:permissions)		{ user.permissions.create(allowed_action: create(:bookings_edit))}
			let(:booking)					{ build(:booking, user_id: other_user.id) }
			subject  							{ BookingSlots::Properties.new(date, user)}

			it { expect(subject.edit_booking? booking).to be_false }

		end

	end

end