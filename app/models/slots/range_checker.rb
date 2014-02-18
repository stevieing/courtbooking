module Slots
	class RangeChecker < Core
		def initialize(from, to, slots)
			@slots = slots
			@series = Series.new(from, to, slots.slot_time)
		end

		def collect
			@slots.all.find_all { |slot| superset_of? slot}
		end

		def reject
			@slots.all.reject { |slot| superset_of? slot}
		end

		def reject!
			@slots.all.reject! { |slot| superset_of? slot}
		end

		def slots_between
			collect.count
		end

		def superset_of?(slot)
			@series.include? slot.series
		end
	end
end