module Table
  #
  # = Table::Cell::CalendarDate
  #
  #  Does what it says on the tin. Used for the Calendar.
  #  outputs the day of the month as the text.
  #  If the date passed is the same date as the courts page currently
  #  being shown then no link is added and a class of selected.
  #  Otherwise a link is added which will take the user to the courts page
  #  for that date.
  #
  module Cell
    class CalendarDate

      include Rails.application.routes.url_helpers
      include Table::Cell::Base

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