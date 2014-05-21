require "spec_helper.rb"

describe Slots::ActiveRecordSlots do

  before(:each) do
    create_settings_constant
  end

  describe "#add_slot_method" do

    with_model :TestSlotMethod do
      table do |t|
        t.string :time_from
        t.string :time_to
      end
      model do
        include Slots::ActiveRecordSlots
      end
    end

    context "slot" do
      subject { TestSlotMethod.new(time_from: "08:00", time_to: "08:30") }

      it { expect(subject.slot).to be_valid }
      it { expect(subject.slot.from).to eq("08:00") }
      it { expect(subject.slot.to).to eq("08:30") }
    end

    context "booking slot" do
      subject { build(:booking, time_from: "08:00", time_to: "08:30") }

      it { expect(subject.slot).to be_valid }
    end

    context "activity slot" do

      before(:each) do
        Settings.stub(:slots).and_return(build(:court_slots))
      end

      subject { build(:event, time_from: "08:00", time_to: "12:00") }
      it { expect(subject.slot).to be_valid }
    end

    context "opening time with slot" do

      subject { build(:opening_time, time_from: "08:00", time_to: "12:00") }
      it { expect(subject.slot).to be_valid }

    end

  end

end