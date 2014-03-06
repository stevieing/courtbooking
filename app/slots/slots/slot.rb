module Slots
	class Slot
		include Comparable

		attr_reader :from, :to, :series
		delegate :all, to: :series

		def initialize(from, to)
			@from, @to = from, to
		end

		def valid?
			@from && @to
		end

		def <=>(other)
		 	@from <=> other.from && @to <=> other.to
		end

		def to_a
			[@from, @to]
		end

		def between
			( @series.nil? ? to_a.compact.count : @series.count ) - 1
		end

		def inspect
			"<#{self.class}: @from=#{@from}, @to=#{@to}>"
		end
		
	end

end