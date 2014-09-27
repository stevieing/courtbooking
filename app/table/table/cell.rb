module Table
  #
  # = Table::Cell
  #
  # each cell relates to an HTML cell.
  # it will contain the minimum amount of information.
  # e.g. text, class and row span.
  # There are various types of cell based on the event
  # that is happening at that time.
  #
  module Cell

    extend ActiveSupport::Autoload

    autoload :Base
    autoload :NullCell
    autoload :Blank
    autoload :Text
    autoload :Activity
    autoload :Booking
    autoload :CalendarDate
    autoload :Closed
    autoload :NullCell

  end

end