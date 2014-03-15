def options
	{slot_first: "06:00", slot_last: "17:00", slot_time: 30}
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

	factory :court_slots, :class => CourtSlots do
		initialize_with { new(options) }
	end

	factory :grid, :class => Slots::Grid do
		count 4
		original { FactoryGirl.build(:court_slots) }

		initialize_with { new(count, original) }
	end

end