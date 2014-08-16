require "spec_helper"

describe BookingMailer do

  before(:each) do
    stub_settings
  end

  describe "booking_confirmation" do
    let(:booking) { create(:booking)}
    let(:mail) { BookingMailer.booking_confirmation(booking) }

    it "renders the headers" do
      mail.subject.should eq("Booking Confirmation - Stamford Squash Club")
      mail.to.should eq([booking.user.email, booking.opponent.email])
      mail.from.should eq(["bookings@stamfordsquashclub.org.uk"])
    end

    it "renders the body" do
      mail.body.encoded.should include("#{booking.time_and_place}")
    end
  end

  describe "booking_deletion" do
    let(:booking) { create(:booking)}
    let(:mail) { BookingMailer.booking_cancellation(booking) }

    it "renders the headers" do
      mail.subject.should eq("Booking Cancelled - Stamford Squash Club")
      mail.to.should eq([booking.user.email, booking.opponent.email])
      mail.from.should eq(["bookings@stamfordsquashclub.org.uk"])
    end

    it "renders the body" do
      mail.body.encoded.should include("#{booking.time_and_place}")
    end
  end

end
