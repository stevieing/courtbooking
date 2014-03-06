module BookingSlots

	class HeaderRow < BookingSlots::Row
		def initialize(courts)
			@courts, @heading = courts, true
			@cells = create_cells.wrap(BookingSlots::Cell.new)
		end

		private

		def create_cells
			[].tap do |cells|
				@courts.each do |court|
					cells << BookingSlots::Cell.new("Court #{court.number.to_s}")
				end
			end
		end
	end

end