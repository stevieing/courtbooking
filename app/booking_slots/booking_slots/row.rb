module BookingSlots

	class Row
		include Enumerable

		attr_reader :cells, :klass
		delegate :last, to: :cells

		def initialize(cells = [])
			@cells, @heading = cells, false
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

	end

end