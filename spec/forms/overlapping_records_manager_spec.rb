require 'spec_helper'

describe OverlappingRecordsManager do

  with_model :MyModel do
    table do |t|
      t.date    :date_from
      t.string  :time_from
      t.string  :time_to
      t.integer :court_id
    end
    model do
     include OverlappingRecordsManager
     validate :verify_overlapping_records_removal
     def initialize(*args)
      @allow_removal = true
      super
     end
    end
  end

  class SurrogateModel
    include OverlappingRecordsManager
    attr_accessor :booking
    overlapping_object :booking
    def initialize(booking)
      @allow_removal = true
      @booking = booking
    end
    def valid?
      true
    end
  end

  before(:each) do
    stub_dates("26 March 2014", "19:00")
    stub_settings
  end

  let(:attributes)  { { date_from: Date.today+1, time_from: "19:00", time_to: "20:00", court_id: 1}}
  let!(:booking)    { create(:booking, date_from: Date.today+2) }
  let!(:closure)    { create(:closure) }
  let!(:event)      { create(:event) }

  describe '#allow_removal' do

    subject { MyModel.new }

    it { expect(subject).to respond_to(:allow_removal) }
    it { expect(subject).to respond_to(:allow_removal=)}

  end

  describe '#remove_overlapping' do

    before(:each) do
      allow_any_instance_of(OverlappingRecords).to receive(:get_records).and_return(Booking.all+Activity.all)
    end

    it { expect{MyModel.new(attributes).remove_overlapping}.to change{Booking.all.empty?}.from(false).to(true) }
    it { expect{MyModel.new(attributes).remove_overlapping}.to change{Activity.all.empty?}.from(false).to(true) }

    it "should send an email if it removes a booking" do
      expect(BookingMailer).to receive(:booking_cancellation)
        .with(booking).and_return(BookingMailer.booking_cancellation(booking))
      MyModel.new(attributes).remove_overlapping
    end

  end

  describe '#overlapping_object' do

    it { expect{SurrogateModel.new(booking).remove_overlapping}.to change{Booking.all.empty?}.from(false).to(true) }
  end

  describe '#allow_removal?' do
    let(:my_model) { MyModel.new}

    before(:each) do
      allow_any_instance_of(OverlappingRecords).to receive(:get_records).and_return(Booking.all+Activity.all)
      my_model.allow_removal = false
    end

    it { expect(my_model.allow_removal?).to be_false}
    it { expect{my_model.remove_overlapping}.to_not change{Booking.all.empty?}}
    it { expect{my_model.remove_overlapping}.to_not change{Activity.all.empty?}}

  end

  describe 'validate' do

    let(:my_model) { MyModel.new(attributes)}

    context '#allow_removal?' do
      before(:each) do
        allow_any_instance_of(OverlappingRecords).to receive(:get_records).and_return(Booking.all+Activity.all)
      end

      context 'true' do
        it { expect(my_model.valid?).to be_true}
        it { expect{my_model.remove_overlapping}.to change{Booking.all.empty?}}
        it { expect{my_model.remove_overlapping}.to change{Activity.all.empty?}}
      end

      context 'false' do
        before(:each) do
          my_model.allow_removal = false
          my_model.remove_overlapping
        end

        it { expect(my_model.valid?).to be_false}
        it { expect(my_model.errors).to have(1).item}
        it { expect(my_model.errors.full_messages).to include("There are records which are affected by this submission. Please approve their removal before continuing.")}
        it { expect(Booking.all).to_not be_empty}
        it { expect(Activity.all).to_not be_empty}
      end
    end

    context 'no records' do
      before(:each) do
        my_model.remove_overlapping
      end

      it { expect(my_model.valid?).to be_true}
      it { expect(my_model.errors).to have(0).items}
      it { expect(Booking.all).to_not be_empty}
      it { expect(Activity.all).to_not be_empty}

    end

  end
end