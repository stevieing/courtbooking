module Slots
	module Slot
		class Base
			attr_reader :from, :to

			def initialize(from, to)
				@from, @to = from, to
			end
			
		end
	end
end