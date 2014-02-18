module Slots
	class Pair < Core
		attr_reader :from, :to, :series
		delegate :all, to: :series

		def initialize(from, constraints)
			@constraints = constraints
			@from = from
			unless @from.nil?
				@to = set_to
				@series = Series.new(@from, @to, @constraints.slot_time)
			end
		end

		def valid?
			return false if @from.nil?
			@constraints.cover? @from
		end

		def inspect
			"<#{self.class}: @from=#{@from}, @to=#{@to} @series=#{@series.inspect}>"
		end

		private

		def set_to
			(convert!(@from) + @constraints.slot_time.minutes).to_s(:hrs_and_mins)
		end

	end

end