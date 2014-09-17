def options
	{slot_first: "06:00", slot_last: "17:00", slot_time: 30}
end

def courts
  FactoryGirl.create_list(:court_with_opening_and_peak_times, 4)
end

FactoryGirl.define do
	factory :slot, :class => Slots::Slot do
		from "06:30"
		to "07:00"
		constraints { build(:constraints) }

  	initialize_with { new(from, to, constraints) }
	end

	factory :constraints, :class => Slots::Constraints do
		initialize_with { new(options) }
	end

	factory :slots, :class => Slots::Base do
		initialize_with { new(options.merge(courts: courts)) }
	end

	factory :grid, :class => Slots::Grid do
		original { FactoryGirl.build(:slots) }

		initialize_with { new(original, courts) }
	end

end