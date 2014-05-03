module BookingSlots
  module Cell
    class Booking
      include Record

      include Rails.application.routes.url_helpers

      def initialize(booking, user)
        @booking, @user = booking, user
        @link = link_for
        @text = text_for
        @klass = klass_for
      end

    private

      def new_record?
        @new_record ||= @booking.new_record?
      end

      def in_the_future?
        @in_the_future ||= @booking.in_the_future?
      end

      def new_and_ahead?
        new_record? && in_the_future?
      end

      def editable?
        @user.allow?(:bookings, :edit, @booking)
      end

      def link_for
        return unless in_the_future?
        return court_booking_path(@booking.new_attributes) if new_record?
        return edit_booking_path(@booking) if editable?
      end

      def text_for
        new_and_ahead? ? @booking.link_text : @booking.players
      end

      def klass_for
        new_record? ? "free" : "booking"
      end

    end
  end
end