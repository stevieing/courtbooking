require 'spec_helper'

describe Slots::Base do

	it { expect(described_class).to include(Enumerable)}

	let(:all_slots) 		{ ["06:20", "07:00", "07:40", "08:20", "09:00"] }
	let(:closing_time)	{ "09:40" }
	let(:slot_time)			{ 40 }
	let(:options)				{ {slot_first: all_slots.first.to_time, slot_last: all_slots.last.to_time, slot_time: slot_time}}
	let(:range) 				{["07:00", "08:20"]}
	let(:collection) 		{["07:00","07:40"]}
	let(:rejection) 		{["06:20", "08:20", "09:00"]}
	subject  						{ Slots::Base.new(options)}

	its(:slots)  		{ should have(all_slots.count).items }
	its(:all)		 		{ should have(all_slots.count).items }
	its(:empty?) 		{ should be_false}

	it { expect(subject.all? {|slot| all_slots.include? slot.from}).to be_true }
	it { expect(subject.last.from).to eq(all_slots.last)}
	it { expect(subject.first.from).to eq(all_slots.first)}
	it { expect(subject.current.from).to eq(all_slots.first)}

	describe 'movement' do
		let(:shove) {3}

		context '#up' do
			it { expect{subject.up}.to change{subject.current.from}.from(all_slots.first).to(all_slots[1])}
	  	it { expect{subject.up(shove)}.to change{subject.current.from}.from(all_slots.first).to(all_slots[shove])}
		end

		context '#down' do
			before(:each) do
				subject.up(3)
			end

			it { expect{subject.down}.to change{subject.current.from}.from(all_slots[shove]).to(all_slots[shove-1]) }
			it { expect{subject.down(shove)}.to change{subject.current.from}.from(all_slots[shove]).to(all_slots.first) }
			
		end
	  
	end

	describe 'manipulation' do	

		context 'ranges' do
			it { expect(subject.collect_range(range.first, range.last).count).to eq(collection.count)}
			it { expect(subject.reject_range(range.first, range.last).count).to eq(rejection.count)}
			it { expect{subject.reject_range!(range.first, range.last)}.to change{subject.all.count}.from(all_slots.count).to(rejection.count)}
			
		end

	end

	describe '#dup' do
		let(:copy) { subject.dup}

		before(:each) do
			subject.up(3)
		end

		it { expect{subject.reject_range!(range.first, range.last)}.to_not change{copy.all.count}.from(all_slots.count).to(rejection.count)}
		it { expect(copy.current.from).to eq(all_slots.first) }
		it { expect{subject.up(1)}.to_not change{copy.current.from}.from(all_slots.first).to(all_slots[1])}

		context '#freeze_slots' do
			before(:each) do
				copy.reject_range!(range.first, range.last)
				copy.freeze_slots
				@copycopy = copy.dup
			end

			it { expect(@copycopy.slots).to eq(copy.slots)}
			it { expect{copy.up}.not_to change{@copycopy.current.from}.from(all_slots.first).to(all_slots.last)}
			it { expect{@copycopy.up}.not_to change{copy.current.from}.from(all_slots.first).to(all_slots.last)}

		end
	  
	end

	describe '#valid_slot_times' do

		before(:each) do
			DateTime.stub(:now).and_return(DateTime.parse("07:20"))
		end

		it { expect(subject.valid_slot).to be_valid}

		context 'end of the day' do
			before(:each) do
				DateTime.stub(:now).and_return(DateTime.parse("08:40"))
			end

			it { expect(subject.valid_slot).to be_valid}
			
		end

		context 'invalid' do
			before(:each) do
				DateTime.stub(:now).and_return(DateTime.parse("09:01"))
			end

			it { expect(subject.valid_slot).not_to be_valid}
		end
		
	end

	describe '#slots_between' do
		it { expect(subject.slots_between(all_slots.first, all_slots.last)).to eq(4)}
	  
	end
	

end