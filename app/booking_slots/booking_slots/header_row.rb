module BookingSlots

	class HeaderRow < BookingSlots::Row

		def initialize(header)
			@header, @heading = header, true
			@cells = create_cells
		end

		private

		def create_cells
      @header.collect { |cell| BookingSlots::Cell.new(cell) }
		end

	end

end