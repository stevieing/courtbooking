module BookingSlots
	
	#
	# TODO: records is only here to pass through to CellBuilder. Need to remove it.
	# this signifies a flaw in my logic.
	#
	class SlotRow < BookingSlots::Row
		def initialize(slots, records)
			@slots, @records = slots, records
			@cells = create_cells.wrap(BookingSlots::Cell.new(@slots.current_slot_time))
			@klass = BookingSlots::HtmlKlass.new(@slots.current_time).value
		end

		private

		def create_cells
			[].tap do |cells|
				until @records.courts.end?
					cells << BookingSlots::CellBuilder.new(@slots, @records).add
					@records.courts.up
				end
				@records.courts.reset!
			end
		end

	end

end