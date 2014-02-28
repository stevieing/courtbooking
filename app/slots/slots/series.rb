module Slots
	class Series
		include Enumerable
		include Helpers

		attr_reader :range

		def initialize(slot, constraints)
			@slot, @constraints = slot, constraints
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

		def cover?(time)
			(@range.first..@range.last).cover?(time)
		end

		private

		def create_range
			if @constraints.valid?
				to_range(@slot.from, @slot.to, @constraints.slot_time)
			else
				@slot.to_a
			end
		end
	end
end