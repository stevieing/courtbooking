module Permissions
  class BookingPolicy

    include Rails.application.routes.url_helpers

    attr_reader :booking

    def initialize(booking, bookings_policy)
      @booking, @policy = booking, bookings_policy
      set_constraints
    end

    def text
      new_record? && in_the_future? ? @booking.link_text : @booking.players
    end

    def link
      if in_the_future?
        if new_record?
          court_booking_path(@booking.new_attributes)
        elsif @policy.edit?(@booking)
          edit_booking_path(@booking)
        end
      end
    end

    def new_record?
      @new_record
    end

    def in_the_future?
      @in_the_future
    end

  private

    def set_constraints
      @new_record     = @booking.new_record?
      @in_the_future  = @booking.in_the_future?
    end
  end
end