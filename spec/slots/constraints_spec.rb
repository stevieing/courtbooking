require "spec_helper.rb"

describe Slots::Constraints do

	let(:time_first) 		{ "06:00" }
	let(:time_last) 		{ "17:00" }
	let(:time_step)		 	{ 30 }
	let(:options)				{ {slot_first: time_first, slot_last: time_last, slot_time: time_step} }

	describe '#setup' do
		before(:each) do
			Slots::Constraints.setup do |config|
				config.slot_first 	= time_first.to_time
				config.slot_last 		= time_last.to_time
				config.slot_time 		= time_step
			end
		end

		it { expect(Slots::Constraints.slot_first).to eq(time_first.to_time) }
		it { expect(Slots::Constraints.slot_last).to eq(time_last.to_time) }
		it { expect(Slots::Constraints.slot_time).to eq(time_step) }
		it { expect(Slots::Constraints.new.slot_first).to eq(time_first.to_time) }
		
	end

	subject { Slots::Constraints.new(options)}

	describe '#new' do

		its(:slot_first) 	{ should eq(time_first.to_time)}
		its(:slot_last) 	{ should eq(time_last.to_time)}
		its(:slot_time) 	{ should eq(time_step)}

		it { expect(subject.slot).to be_valid}
		it { expect(subject.series).to be_instance_of(Slots::Series)}
	  
	end

	describe '#cover?' do

		it { expect(subject.cover? "05:00").to be_false }
		it { expect(subject.cover? "06:00").to be_true }
		it { expect(subject.cover? "12:00").to be_true }
		it { expect(subject.cover? "17:00").to be_true }
		it { expect(subject.cover? "18:00").to be_false }

		context 'whatever the day' do
			before(:each) do
				Time.stub(:now).and_return((Date.today-2.days).to_time)
			end

			it { expect(subject.cover? "05:00").to be_false }
			it { expect(subject.cover? "06:00").to be_true }
			it { expect(subject.cover? "12:00").to be_true }
			it { expect(subject.cover? "17:00").to be_true }
			it { expect(subject.cover? "18:00").to be_false }
		end

	end

	describe '#new_constraint' do

		subject { Slots::Constraints.new_constraint(time_first, time_last, time_step)}

		it { expect(subject.instance_of?(Slots::Constraints)).to be_true}
	end

	describe '#valid' do
		it { expect(subject).to be_valid }
		it { expect(Slots::Constraints.new(options.except(:slot_time))).to_not be_valid  }
		it { expect(Slots::Constraints.new(options.except(:slot_first))).to_not be_valid }
		it { expect(Slots::Constraints.new(options.except(:slot_last))).to_not be_valid  }


	end

end