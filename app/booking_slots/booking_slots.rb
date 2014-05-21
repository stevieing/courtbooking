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
  autoload :BookingsGrid
  autoload :Cell
  autoload :Calendar
  autoload :Dates

  eager_autoload do

    autoload :Container
    autoload :Row

  end

end