module BookingSlots

	class Row
		include Enumerable

		attr_reader :cells, :klass
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

end