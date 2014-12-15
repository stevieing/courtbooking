
FactoryGirl.define do
	factory :slot, class: Slots::Slot do
		from "06:30"
		to "07:00"
		constraints { build(:constraints) }

  	initialize_with { new(from: from, to: to, constraints: constraints) }
	end

	factory :constraints, class: Slots::Constraints do
    options {{slot_first: "06:00", slot_last: "17:00", slot_time: 30}}
		initialize_with { new(options) }
	end

	factory :grid, class: Slots::Grid do
    options {{slot_first: "06:00", slot_last: "17:00", slot_time: 30}}
    courts { FactoryGirl.create_list(:court_with_opening_and_peak_times, 4) }

		initialize_with { new(options.merge(courts: courts)) }
	end

   factory :court_slot, class: Slots::CourtSlot do
    court { create(:court) }
    slot { build(:slot) }

    initialize_with { new(court, slot)}
  end

end