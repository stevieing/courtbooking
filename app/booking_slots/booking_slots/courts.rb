module BookingSlots
	class Courts

		include Enumerable

		attr_reader :courts, :index

		def initialize(properties)
			@properties = properties
			@courts = Court.includes(:opening_times)
			reset!
		end

		def reset!
			@index = 0
		end

		def each(&block)
			@courts.each(&block)
		end

		def current
			@courts[@index]
		end

		def up(n=1)
			@index += n
		end

		def end?
			@index >= @courts.count
		end

		def valid?
			@properties.valid?
		end

		def inspect
			"<#{self.class}: @index=#{@index}, @courts=#{@courts.inspect}>"
		end

		alias_method :all, :courts
	end
end