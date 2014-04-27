module BookingSlots
  class Bookings

    attr_reader :bookings

    def initialize(properties)
      @properties = properties
      @user = @properties.user
      @bookings = Booking.by_day(@properties.date)
    end

    def current_record(courts, slots)
      @bookings.select_first_or_initialize(court: courts.current, time_from: slots.current.from) do |booking|
        booking.date_from_text  = @properties.date.to_s(:uk)
        booking.time_to         = slots.current.to
      end
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