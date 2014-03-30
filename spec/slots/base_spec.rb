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
	let(:slot_range)		{ build(:slot, from: range.first, to: range.last, constraints: build(:constraints, options: options))}
	subject  						{ Slots::Base.new(options)}

	it { should be_valid }

	its(:slots)  		{ should have(all_slots.count).items }
	its(:all)		 		{ should have(all_slots.count).items }
	its(:empty?) 		{ should be_false}

	it { expect(subject.all? {|slot| all_slots.include? slot.from}).to be_true }
	it { expect(subject.last.from).to eq(all_slots.last)}
	it { expect(subject.first.from).to eq(all_slots.first)}
	it { expect(subject.current.from).to eq(all_slots.first)}

  it_behaves_like IndexManager do
    let(:enum_attribute)  { :@slots }
  end

	describe 'manipulation' do

		context 'ranges' do
			it { expect(subject.collect_range(slot_range).count).to eq(collection.count)}
			it { expect(subject.reject_range(slot_range).count).to eq(rejection.count)}
			it { expect{subject.reject_range!(slot_range)}.to change{subject.all.count}.from(all_slots.count).to(rejection.count)}

		end

	end

	describe '#dup' do
		let(:copy) { subject.dup}

		before(:each) do
			subject.up(3)
		end

		it { expect{subject.reject_range!(slot_range)}.to_not change{copy.all.count}.from(all_slots.count).to(rejection.count)}
		it { expect(copy.current.from).to eq(all_slots.first) }
		it { expect{subject.up(1)}.to_not change{copy.current.from}.from(all_slots.first).to(all_slots[1])}

		context '#freeze' do
			before(:each) do
				copy.reject_range!(slot_range)
				copy.freeze
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
		let(:slot_between)		{ build(:slot, from: all_slots.first, to: all_slots.last, constraints: build(:constraints, options: options))}
		it { expect(subject.slots_between(slot_between)).to eq(4)}

	end

	describe '#current_slot_time' do

		it { expect(subject.current_slot_time).to eq("06:20")}
		it { expect{subject.up(3)}.to change{subject.current_slot_time}.from("06:20").to("08:20")}

	end

	describe '#current_time' do
		it { expect(subject.current_time).to eq("06:20".to_datetime)}
	end

	describe 'inherited' do

		subject { CourtSlots.new(options) }

		it { should be_kind_of(Slots::Base)}
	end

end