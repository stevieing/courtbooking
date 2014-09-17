module Slots
  module Cell
    class Booking
      include Rails.application.routes.url_helpers
      include Slots::Cell::Base

      def initialize(booking, user)
        @booking, @user = booking, user
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
        return court_booking_path(@booking.new_attributes) if new_record?
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