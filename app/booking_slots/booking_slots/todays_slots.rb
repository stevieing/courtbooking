module BookingSlots
	class TodaysSlots

		include Enumerable

		attr_reader :grid
		delegate [], :up, :current_slot_time, :current, :synced?, :end?, :skip, to: :grid

		def initialize(slots, records)
			@records = records
			@records.remove_closed_slots!(slots)
			slots.freeze
			@grid = Slots::Grid.new(@records.courts.count, slots)
		end

		def each(&block)
			@grid.each(&block)
		end

		def valid?
			@grid.valid?
		end

		def inspect
			"<#{self.class}: @grid=#{@grid.inspect}>"
		end

	end
end