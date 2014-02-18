require "spec_helper"

describe Slots::Series do

	let(:slot_range) 		{ ["06:00", "06:30", "07:00", "07:30", "08:00"] }
	let(:slot_time)			{ 30 }
	
	subject { Slots::Series.new(slot_range.first, slot_range.last, slot_time)}

	its(:all) 					{ should eq(slot_range)}

	describe "#include?" do

		context 'valid' do
			let(:range_within) { Slots::Series.new("06:30", "07:30", slot_time) }
			it { expect(subject.include?(range_within)).to be_true }
		end

		context 'invalid' do

			context 'overlap' do
				let(:range_without) { Slots::Series.new("08:00", "08:30", slot_time) }
				it { expect(subject.include?(range_without)).to be_false }
			end

			context 'outside' do
				let(:range_without) { Slots::Series.new("09:00", "09:30", slot_time) }
				it { expect(subject.include?(range_without)).to be_false }
			end
			
		end
	  
	end

end