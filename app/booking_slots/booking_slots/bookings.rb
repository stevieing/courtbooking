module BookingSlots
  class Bookings

    attr_reader :bookings

    def initialize(properties)
      @properties = properties
      @bookings = Booking.by_day(@properties.date)
    end

     def current_booking(courts, slots)
      @bookings.select_first_or_initialize(court_id: courts.current.id, time_from: slots.current.from) do |booking|
        booking.date_from  = @properties.date.to_s(:uk)
        booking.time_to    = slots.current.to
      end
    end

    #
    # TODO: Again this is interim.
    # There needs to be a full refactor of the users/permissions/policies.
    #
    def current_record(courts, slots)
      booking_policy = Permissions::BookingPolicy.new(current_booking(courts, slots), @properties.policy)
      BookingSlots::CurrentRecord.create(booking_policy.booking) do |record|
        record.text = booking_policy.text
        record.link = booking_policy.link
        record.klass  = BookingSlots::HtmlKlass.new(booking_policy.booking).value unless booking_policy.new_record?
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