module Slots
	class CourtSlot < Slots::Slot
		include Slots::Helpers
		
		def initialize(from, constraints)
			@from, @constraints = from, constraints
			save if valid?
		end

		def valid?
			return false if @from.nil?
			@constraints.cover? @from
		end

		def inspect
			"<#{self.class}: @from=#{@from}, @to=#{@to} @series=#{@series.inspect}>"
		end

		private

		def save
			@to = set_to
			@series = Slots::Series.new(self, @constraints)
		end

		def set_to
			@from.time_step(@constraints.slot_time)
		end
	end
	
end