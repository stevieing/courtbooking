require "spec_helper"

describe Slots::Series do

  let(:slot_range)    { ["06:00", "06:30", "07:00", "07:30", "08:00"] }
  let(:slot_time)     { 30 }
  let(:slot)          { Slots::Slot.new(slot_range.first, slot_range.last)}
  let(:options)       { {slot_first: slot_range.first, slot_last: slot_range.last, slot_time: slot_time} }
  let(:constraints)   { Slots::Constraints.new(options)}

  subject { Slots::Series.new(slot, constraints)}

  context 'with constraints' do

    its(:all)           { should eq(slot_range) }
    its(:to_a)          { should eq(slot_range) }

  end

  context 'without constraints' do

    subject { Slots::Series.new(slot, Slots::NullObject.new)}
    its(:all) { should eq([slot_range.first, slot_range.last])}

  end

  describe "#include?" do

    context 'valid' do
      let(:range_within) { Slots::Series.new(Slots::Slot.new("06:30", "07:30"), constraints) }
      it { expect(subject.include?(range_within)).to be_true }
    end

    context 'invalid' do

      context 'overlap' do
        let(:range_without) { Slots::Series.new(Slots::Slot.new("08:00", "08:30"), constraints) }
        it { expect(subject.include?(range_without)).to be_false }
      end

      context 'outside' do
        let(:range_without) { Slots::Series.new(Slots::Slot.new("09:00", "09:30"), constraints) }
        it { expect(subject.include?(range_without)).to be_false }
      end

    end

  end

  describe '#cover?' do

    it { expect(subject.cover?("05:00")).to be_false }
    it { expect(subject.cover?("05:59")).to be_false }
    it { expect(subject.cover?("06:00")).to be_true }
    it { expect(subject.cover?("06:01")).to be_true }
    it { expect(subject.cover?("07:00")).to be_true }
    it { expect(subject.cover?("07:59")).to be_true }
    it { expect(subject.cover?("08:00")).to be_true }
    it { expect(subject.cover?("08:01")).to be_false }
    it { expect(subject.cover?("09:00")).to be_false }

    context '#whatever the day' do

      before(:each) do
        Time.stub(:now).and_return((Date.today-2.days).to_time)
      end

      it { expect(subject.cover?("05:00")).to be_false }
      it { expect(subject.cover?("06:00")).to be_true }
      it { expect(subject.cover?("08:00")).to be_true }
      it { expect(subject.cover?("09:00")).to be_false }

    end
  end

end