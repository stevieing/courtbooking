require "spec_helper"

describe Slots::RangeChecker do

  let(:options)       { { slot_time: 30, slot_first: "07:00", slot_last: "17:00"}}
  let(:slots)         { Slots::Base.new(options)}
  let(:slot)          { Slots::Slot.new("11:00", "15:00", slots.constraints)}

  subject { Slots::RangeChecker.new(slot, slots)}

  it { expect(subject.collect.count).to eq(8)}
  it { expect(subject.collect.first.from).to eq("11:00")}
  it { expect(subject.collect.last.to).to eq("15:00")}

  it { expect(subject.reject.count).to eq(13)}
  it { expect(subject.reject.inspect).to_not include("11:30")}
  it { expect(subject.reject.inspect).to_not include("14:30")}
  it { expect{subject.reject!}.to change{slots.count}.from(21).to(13) }

  it { expect(subject.slots_between).to eq(subject.collect.count)}

end