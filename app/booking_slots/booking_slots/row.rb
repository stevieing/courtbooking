module BookingSlots

	class Row
		include Enumerable

		attr_reader :cells
		delegate :last, to: :cells

		def initialize
			@cells, @heading = create_cells, false
		end

		def each(&block)
			@cells.each(&block)
		end

		def heading?
			@heading
		end

		def inspect
			"<#{self.class}: @heading=#{@heading}, @cells=#{@cells.each {|cell| cell.inspect}}>"
		end

		def [](index)
			@cells[index]
		end

		def valid?
			!@cells.nil?
		end

		#TODO how can refactor this to have a single method that can be used by children.
		def create_cells(&block)
			[].tap do |cells|
				yield if block_given?
			end
		end
	end

	class HeaderRow < Row
		def initialize(courts)
			@courts, @heading = courts, true
			@cells = create_cells.wrap(Cell.new)
		end

		private

		def create_cells
			[].tap do |cells|
				@courts.each do |court|
					cells << Cell.new("Court #{court.number.to_s}")
				end
			end
		end
	end

	class SlotRow < Row
		def initialize(slots, records)
			@slots, @records = slots, records
			@cells = create_cells.wrap(Cell.new(slots.current_slot_time))
		end

		private

		def create_cells
			[].tap do |cells|
				until @records.courts.end?
					cells << (@slots.synced?(@records.courts.index) ? Cell.new : NullCell.new)
					@records.courts.up
				end
				@records.courts.reset!
			end
		end

	end

end