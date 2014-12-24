###
# An Admin user has full access to all parts of the system equivalent to a superuser.
class Admin < User

  include Permissions

  ##
  # returns all of the current bookings ordered and eager loaded.
  def all_bookings
    Booking.includes(:user, :court).ordered.load
  end
end
