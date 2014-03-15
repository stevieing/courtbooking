require "spec_helper"

describe Slots::RangeChecker do

	let(:slot_first)		{ "07:00"}
	let(:slot_last)			{ "17:00"}
	let(:slot_time)			{ 30 }
	let(:options)				{ { slot_time: 30, slot_first: slot_first, slot_last: slot_last}}
	let(:slots) 				{ Slots::Base.new(options)}
	let(:slot)					{ Slots::Slot.new("11:00", "15:00", slots.constraints)}

	subject { Slots::RangeChecker.new(slot, slots)}

	describe "#collect" do

		let(:collector) { subject.collect}

		it { expect(collector.count).to eq(8)}
		it { expect(collector.first.from).to eq("11:00")}
		it { expect(collector.last.to).to eq("15:00")}
	end

	describe '#reject' do
		let(:rejector) { subject.reject}

		it { expect(rejector.count).to eq(13)}
		it { expect(rejector.inspect).to_not include("11:30")}
		it { expect(rejector.inspect).to_not include("14:30")}

	end

	describe '#reject' do
		it { expect{subject.reject!}.to change{slots.count}.from(21).to(13) }
	end

	describe '#slots_between' do
		let(:between) { subject.slots_between}

		it { expect(between).to eq(subject.collect.count)}
	end
end