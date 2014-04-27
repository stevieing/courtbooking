module BookingSlots
  module Cell
    class CalendarDate < Base

      include Rails.application.routes.url_helpers

      def initialize(date, current_date)
        @date, @current_date = date, current_date
        set_constraints
      end

      def text
        @text ||= @date.day_of_month
      end

      def link
        @link ||= courts_path(@date.to_s) unless current?
      end

      def klass
        @klass ||= "selected" if current?
      end

    private

      def set_constraints
        @current = (@date == @current_date)
      end

      def current?
        @current
      end
    end
  end
end