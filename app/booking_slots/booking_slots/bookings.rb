module BookingSlots
	class Bookings

		attr_reader :bookings
		
		def initialize(properties)
			@properties = properties
			@bookings = Booking.by_day(@properties.date)
		end

		def current_booking(courts, slots)
			@bookings.where(court_number: courts.current.number, time_from: slots.current.from).first_or_initialize do |booking|
				booking.playing_on 	= @properties.date.to_s(:uk)
				booking.time_to 		= slots.current.to
			end
		end

		def current_record(courts, slots)
			nil
		end

		def valid?
			@properties.valid?
		end

		alias_method :all, :bookings

		def inspect
			"<#{self.class}: @bookings=#{@bookings.inspect}>"
		end
		
	end
end