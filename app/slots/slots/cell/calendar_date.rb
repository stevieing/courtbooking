module Slots
  module Cell
    class CalendarDate

      include Rails.application.routes.url_helpers
      include Slots::Cell::Base

      def initialize(date, current_date)
        @text = date.day_of_month
        unless date == current_date
          @link = courts_path(date.to_s)
        else
          @html_class = "selected"
        end
      end

    end

  end

end