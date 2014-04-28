#
#   TODO: abstract out methods for creating rows and cells.
#         abstract out methods for creating header and footer.
#   DONE: Requests times have been reduced 80% by using select and count caching.
#
module BookingSlots

  extend ActiveSupport::Autoload

  autoload :Properties
  autoload :Records
  autoload :TodaysSlots
  autoload :Bookings
  autoload :Unavailable
  autoload :Activities
  autoload :Courts
  autoload :Table
  autoload :Cell
  autoload :HtmlKlass
  autoload :Calendar
  autoload :Dates

  eager_autoload do

    autoload :Row
    autoload :HeaderRow

  end

end