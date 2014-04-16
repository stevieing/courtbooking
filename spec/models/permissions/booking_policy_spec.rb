require 'spec_helper'

describe Permissions::BookingPolicy do

  before(:each) do
    stub_settings
  end

  let(:bookings_policy) { Permissions::BookingsPolicy.new(create(:user))}
  let!(:booking)        { create(:booking)}

  subject { Permissions::BookingPolicy.new(booking, bookings_policy)}


  describe '#text' do

    context 'new record' do

      before(:each) do
        allow(booking).to receive(:new_record?).and_return(true)
      end

      context 'in the past' do
        before(:each) do
          allow(booking).to receive(:in_the_past?).and_return(true)
        end

        it { expect(subject).to have_text(booking.players) }

      end

      context 'in the future' do
        before(:each) do
          allow(booking).to receive(:in_the_future?).and_return(true)
        end

        it { expect(subject).to have_text(booking.link_text) }
      end

    end

    context 'existing record' do

      before(:each) do
        allow(booking).to receive(:new_record?).and_return(false)
      end

      it { expect(subject).to have_text(booking.players) }

    end

  end

  describe '#link' do

    context 'in the past' do
      before(:each) do
        allow(booking).to receive(:in_the_past?).and_return(true)
      end

      it { expect(subject.link).to be_nil }
    end

    context 'in the future' do

      before(:each) do
        allow(booking).to receive(:in_the_future?).and_return(true)
      end

      context 'new record' do
        before(:each) do
          allow(booking).to receive(:new_record?).and_return(true)
        end

        it { expect(subject).to be_a_link_to(court_booking_path(booking.new_attributes))}
      end

      context 'existing record' do
        before(:each) do
          allow(booking).to receive(:new_record?).and_return(false)
        end

        context 'editable' do
          before(:each) do
            allow(bookings_policy).to receive(:edit?).and_return(true)
          end

          it { expect(subject).to be_a_link_to(edit_booking_path(booking))}
        end

        context 'not editable' do
           before(:each) do
            allow(bookings_policy).to receive(:edit?).and_return(false)
          end

          it { expect(subject.link).to be_nil}
        end
      end
    end
  end
end