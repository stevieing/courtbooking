module Slots
	class ActivitySlot < Slot
		def initialize(from, to, constraints)
			super(from, to)
			@constraints = constraints
			save if valid?
		end

		def valid
			super && @constraints.valid?
		end

		def inspect
			"<#{self.class}: @from=#{@from}, @to=#{@to} @series=#{@series.inspect}>"
		end

		private

		def save
			@series = Slots::Series.new(self, @constraints)
		end
	end
end