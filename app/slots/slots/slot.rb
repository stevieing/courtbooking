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

	class RecordSlot < Slot
		def initialize(from, to)
			super(from, to)
			save if valid?
		end

		private

		def save
			@series = Series.new(self, NullObject.new)
		end
	end

	class CourtSlot < Slot
		include Helpers
		
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
			@series = Series.new(self, @constraints)
		end

		def set_to
			@from.time_step(@constraints.slot_time)
		end
	end

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
			@series = Series.new(self, @constraints)
		end
	end
	
end