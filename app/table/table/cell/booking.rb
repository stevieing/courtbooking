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

  module Cell
    class Booking
      include Rails.application.routes.url_helpers
      include Table::Cell::Base

      def initialize(booking, user, court_slot)
        @booking, @user, @court_slot = booking, user, court_slot
        @text = text_for
        @link = link_for
        @html_class = class_for
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

    end

  end

end