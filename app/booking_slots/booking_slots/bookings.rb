module BookingSlots
  class Bookings

    include Rails.application.routes.url_helpers

    attr_reader :bookings

    def initialize(properties)
      @properties = properties
      @bookings = Booking.by_day(@properties.date)
    end

    #TODO: This is an interim solution to speed things up.
    # This needs to be moved into ActiveRecord::Relation
    def current_booking(courts, slots)
      first_or_initialize(@bookings.select { |booking| booking.court_id == courts.current.id && booking.time_from == slots.current.from }) do |booking|
        booking.court_id   = courts.current.id
        booking.date_from  = @properties.date.to_s(:uk)
        booking.time_from  = slots.current.from
        booking.time_to    = slots.current.to
      end
    end

    def current_record(courts, slots)
      booking = current_booking(courts, slots)
      BookingSlots::CurrentRecord.create(booking) do |record|
        if booking.in_the_past?
          record.text = booking.players
        else
          if booking.new_record?
            record.text   = booking.link_text
            record.link   = court_booking_path(booking.date_from, booking.time_from, booking.time_to, booking.court_id.to_s)
          else
            record.text   = booking.players
            record.link   = edit_booking_path(booking) if @properties.edit_booking?(booking)
            record.klass  = BookingSlots::HtmlKlass.new(booking).value
          end
        end
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

    def first_or_initialize(selection, &block)
      selection.first || Booking.new(&block)
    end

  end
end