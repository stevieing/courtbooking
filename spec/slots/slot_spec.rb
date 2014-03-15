require "spec_helper"

describe Slots::Slot do
	
	describe '#basic' do

		subject { Slots::Slot.new("06:30", "07:00")}

		its(:from) 		{ should eq("06:30")}
		its(:to)			{ should eq("07:00")}
		its(:to_a)		{ should eq(["06:30","07:00"])}
		it 						{ should be_valid }
		its(:between)	{ should eq(1)}

		context 'invalid' do
			it { expect(Slots::Slot.new("06:30", nil)).to_not be_valid }
			it { expect(Slots::Slot.new(nil, "06:30")).to_not be_valid }
		end

		describe '#==' do

			let(:other) { Slots::Slot.new("06:30", "07:00") }

			context 'equal' do
				it { expect(subject).to eq(Slots::Slot.new("06:30", "07:00")) }
			end

			context 'not equal' do
				it { expect(subject).to_not eq(Slots::Slot.new(nil, "07:00")) }
				it { expect(subject).to_not eq(Slots::Slot.new("06:30", nil)) }
			end
		end

	end

	describe '#record' do

		subject { Slots::Slot.new("06:30", "07:00")}

		it 						{ should be_kind_of(Slots::Slot)}
		it 						{ expect(subject.series.to_a).to eq(["06:30","07:00"])}
		its(:between)	{ should eq(1)}

	end

	describe '#court' do
		let(:slot_first) 		{ "07:00" }
		let(:slot_last)			{ "12:00" }
		let(:slot_time)			{ 30 }
		let(:options)				{ { slot_first: slot_first, slot_last: slot_last, slot_time: slot_time} }
		let(:constraints)		{ Slots::Constraints.new(options) }

		describe '#new' do

			subject { Slots::Slot.new("08:00", nil, constraints)}

			its(:from) 		{ should eq("08:00")}
			its(:to)			{ should eq("08:30")}
			its(:between)	{ should eq(1)}

			it { should be_valid }
			it { expect(subject.all).to eq(["08:00","08:30"])}

			context 'invalid' do

				it { expect(Slots::Slot.new("06:00", nil, constraints)).not_to be_valid }
				it { expect(Slots::Slot.new("13:00", nil, constraints)).not_to be_valid }
				it { expect(Slots::Slot.new(nil, nil, constraints)).not_to be_valid }

			end
	  
		end
	end

	describe '#activity' do
		let(:slot_first) 		{ "07:00" }
		let(:slot_last)			{ "17:00" }
		let(:slot_time)			{ 30 }
		let(:options)				{ { slot_first: slot_first, slot_last: slot_last, slot_time: slot_time} }
		let(:constraints)		{ Slots::Constraints.new(options) }

		describe '#new' do

			subject { Slots::Slot.new("08:00", "12:00", constraints)}

			its(:from) 		{ should eq("08:00")}
			its(:to)			{ should eq("12:00")}
			its(:between)	{ should eq(8)}

			it { should be_valid }
			it { expect(subject.all).to eq(["08:00","08:30","09:00","09:30","10:00","10:30","11:00","11:30","12:00"])}
	  
		end

		describe '#between' do
			subject { Slots::Slot.new("08:00", "8:30", constraints)}
			its(:between)	{ should eq(1)}
		end
	end

end