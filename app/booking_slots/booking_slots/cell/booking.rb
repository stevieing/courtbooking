module BookingSlots
  module Cell
    class Booking < Base

      include Rails.application.routes.url_helpers

      def initialize(booking, user)
        @booking, @user = booking, user
        add_constraints
      end

      def link
        @link ||= link_for
      end

      def text
         @text ||= text_for
      end

      def klass
        @klass ||= klass_for
      end

      def active?
        true
      end

    private

      def add_constraints
        @new_record     = @booking.new_record?
        @in_the_future  = @booking.in_the_future?
        @editable       = @user.allow?(:bookings, :edit, @booking)
      end

      def new_record?
        @new_record
      end

      def in_the_future?
        @in_the_future
      end

      def new_and_ahead?
        new_record? && in_the_future?
      end

      def editable?
        @editable
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