module Table

  #
  # = Table::Cell::Booking
  # There are various types of booking:
  #  * new booking in the future: A link will be output and a class of free added.
  #  * new booking in the past: Empty text with a class of free. A separate class is added at row level.
  #  * existing booking in the future for the current user: Text is the players. A link is added as the user
  #    is allowed to edit it. NB if the user is allowed to edit all bookings then the link is also added.
  #    class of booking.
  #  * existing booking in the future for another user: Text is the players. No link class of booking.
  #  * existing booking in the past: Text is the players. No link. Class of booking.
  #
  # options: court_slot, booking, date, user
  #

  module Cell
    class Booking

      include Table::Cell::Base
      include Rails.application.routes.url_helpers

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
          #b.court_id = @court_slot.court_id
        end
      end

    end

  end

end