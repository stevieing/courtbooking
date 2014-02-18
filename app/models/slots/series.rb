module Slots
	class Series < Core
		include Enumerable

		attr_reader :range

		def initialize(from, to, step)
			@from, @to, @step = convert!(from), convert!(to), step
			@range = create_range
		end

		def each(&block)
			@range.each(&block)
		end

		alias_method :all, :range

		def inspect
			"<#{self.class}: @range=[#{@range.join(",")}]>"
		end

		def include?(other)
			other.to_set.subset?(self.to_set)
		end

		private

		def create_range
			@from.to(@to, @step.minutes).collect { |t| t.to_s(:hrs_and_mins)}
		end
	end
end