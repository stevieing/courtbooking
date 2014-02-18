require "spec_helper"

describe Slots::Pair do

	let(:slot_first) 		{ "07:00" }
	let(:slot_last)			{ "12:00" }
	let(:slot_time)			{ 30 }
	let(:options)				{ { slot_first: slot_first, slot_last: slot_last, slot_time: slot_time} }
	let(:constraints)		{ Slots::Constraints.new(options) }
	
	describe '#new' do

		subject { Slots::Pair.new("08:00", constraints)}

		its(:from) 		{ should eq("08:00")}
		its(:to)			{ should eq("08:30")}

		it { should be_valid }
		it { expect(subject.all).to eq(["08:00","08:30"])}

		context 'invalid' do

			it { expect(Slots::Pair.new("06:00", constraints)).not_to be_valid }
			it { expect(Slots::Pair.new("13:00", constraints)).not_to be_valid }
			it { expect(Slots::Pair.new(nil, constraints)).not_to be_valid }

		end
	  
	end
end