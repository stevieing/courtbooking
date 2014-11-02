module Table

  module Cell

    ###
    # There are various types of booking:
    # * new booking in the future: A link will be output and a class of free added.
    # * new booking in the past: empty text with a class of free. A separate class is added at row level.
    # * existing booking in the future for the current user: Text is the players. A link is added as the user
    #   is allowed to edit it. NB if the user is allowed to edit all bookings then the link is also added.
    #   class of booking.
    # * existing booking in the future for another user: text is the players. No link class of booking.
    # * existing booking in the past: text is the players. No link. Class of booking.
    #
    # options: court_slot, booking, date, user
    class Booking

      include Table::Cell::Base
      include Rails.application.routes.url_helpers

      ##
      # The initializer will do several things:
      # * Add the attributes from the options hash (minus the booking options).
      # * Construct a booking attribute. If a booking object is passed it will be assigned
      #   otherwise a new booking will be constructed from the options.
      # * Construct the text from the booking. If it is a new booking it will use the link text
      #   otherwise it will use the players attribute.
      # * Construct a link unless the booking is in the past. If it is a new booking a link will
      def initialize(options = {})
        set_attributes(options.except(:booking))
        @booking = to_booking(options[:booking])
        @text = text_for
        @link = link_for
        @html_class = class_for
      end

      def remote
        true
      end

    private

      def text_for
        new_and_ahead? ? @booking.link_text : @booking.players || " "
      end

      def link_for
        return unless in_the_future?
        return court_booking_path(@booking.date_from, @court_slot.id) if new_record?
        return edit_booking_path(@booking) if editable?
      end

      def class_for
        new_record? ? "free" : "booking"
      end

      def in_the_future?
        @in_the_future ||= @booking.in_the_future?
      end

      def new_record?
        @new_record ||= @booking.new_record?
      end

      def new_and_ahead?
        new_record? && in_the_future?
      end

      def editable?
        @user.allow?(:bookings, :edit, @booking)
      end

      def set_attributes(options)
        options.each do |key, option|
          instance_variable_set("@#{key}", option)
        end
      end

      def to_booking(booking)
        booking || ::Booking.new do |b|
          b.date_from = @date
          b.time_from = @court_slot.from
          b.time_to = @court_slot.to
          b.court = @court_slot.court
        end
      end

    end

  end

end