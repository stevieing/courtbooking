module BookingSlots
  class Bookings

    include Rails.application.routes.url_helpers

    attr_reader :bookings

    def initialize(properties)
      @properties = properties
      @user = @properties.user
      @bookings = Booking.by_day(@properties.date)
    end

     def current_booking(courts, slots)
      @bookings.select_first_or_initialize(court_id: courts.current.id, time_from: slots.current.from) do |booking|
        booking.date_from  = @properties.date.to_s(:uk)
        booking.time_to    = slots.current.to
      end
    end

    def current_record(courts, slots)
      booking = current_booking(courts, slots)
      BookingSlots::CurrentRecord.create(booking) do |record|
        record.text = booking.link_text
        record.link = link_for(booking)
        record.klass  = html_klass(booking)
      end
    end

    def valid?
      @properties.valid?
    end

    alias_method :all, :bookings

    def inspect
      "<#{self.class}: @bookings=#{@bookings.inspect}>"
    end

  private

    def html_klass(booking)
      booking.new_record? ? "free" : "booking"
    end

    #
    # TODO: This is better but still needs some more work.
    #
    def link_for(booking)
       if booking.in_the_future?
        if booking.new_record?
          court_booking_path(booking.new_attributes)
        elsif @user.allow?(:bookings, :edit, booking)
          edit_booking_path(booking)
        end
      end
    end

  end
end